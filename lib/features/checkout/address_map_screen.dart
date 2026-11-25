import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/geo/geo.dart';
import '../../core/maps/location.dart';
import '../../core/maps/qmap.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/visuals.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// 1m — pick the delivery point on the Yandex map and check it against the
/// delivery zones. Without a MapKit key the map is a placeholder and the
/// saved point is checked as is.
class AddressMapScreen extends ConsumerStatefulWidget {
  const AddressMapScreen({super.key});

  @override
  ConsumerState<AddressMapScreen> createState() => _AddressMapScreenState();
}

class _AddressMapScreenState extends ConsumerState<AddressMapScreen> {
  final _map = QMapController();
  GeoPoint? _point;
  bool _moving = false;

  /// Whether the pin left the point saved with the street address.
  bool _moved = false;

  Future<void> _editAddress(Address current) async {
    final updated = await showModalBottomSheet<Address>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      builder: (_) => _AddressForm(initial: current),
    );
    if (updated == null || !mounted) return;
    await ref
        .read(profileRepositoryProvider)
        .updateAddress(
          Address(street: updated.street, apartment: updated.apartment, floor: updated.floor, location: _point ?? current.location),
        );
    if (!mounted) return;
    setState(() => _moved = false);
    ref.invalidate(profileProvider);
  }

  Future<void> _locate() async {
    final me = await locateMe(context);
    if (me == null || !mounted) return;
    unawaited(_map.showUser());
    if (_map.isLive) {
      await _map.moveTo(me, zoom: 16);
    } else {
      setState(() {
        _point = me;
        _moved = true;
      });
    }
  }

  Future<void> _confirm(Address address, GeoPoint point) async {
    final router = GoRouter.of(context);
    await ref
        .read(profileRepositoryProvider)
        .updateAddress(Address(street: address.street, apartment: address.apartment, floor: address.floor, location: point));
    ref.invalidate(profileProvider);
    router.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final address = ref.watch(profileProvider).value?.address;
    final zonesValue = ref.watch(deliveryZonesProvider);
    final zones = zonesValue.value ?? const <DeliveryZone>[];
    final start = address?.location ?? GeoPoint.almaty;
    final point = _point ?? start;
    final zone = zones.where((z) => z.contains(point)).firstOrNull;
    final outside = zonesValue.hasValue && zone == null;
    final eta = l10n.etaRange('30', '45');
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: address == null
                ? const MapPlaceholder()
                : QMap(
                    center: start,
                    zoom: 15,
                    zones: zones,
                    controller: _map,
                    onCameraMove: () => setState(() => _moving = true),
                    onCameraIdle: (p) => setState(() {
                      _moving = false;
                      _point = p;
                      _moved = address.location == null || distanceKm(p, address.location!) > .03;
                    }),
                    fallback: const _FallbackMap(),
                  ),
          ),
          // The pin stays in the middle; the map moves under it.
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: FractionalTranslation(
                  translation: const Offset(0, -.5),
                  child: AnimatedSlide(
                    offset: Offset(0, _moving ? -.08 : 0),
                    duration: const Duration(milliseconds: 150),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedOpacity(
                          opacity: _moving ? 0 : 1,
                          duration: const Duration(milliseconds: 150),
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: outside ? AppColors.red : AppColors.ink,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              outside ? l10n.outOfZone : eta,
                              style: AppText.ui(12, weight: FontWeight.w700, color: AppColors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Icon(Icons.location_on_rounded, size: 56, color: AppColors.red),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                spacing: 12,
                children: [
                  CircleIconButton(icon: Icons.arrow_back_rounded, tooltip: l10n.back, shadow: true, onPressed: () => context.pop()),
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [BoxShadow(color: Color(0x1A1F1A17), blurRadius: 12, offset: Offset(0, 4))],
                    ),
                    child: Text(l10n.mapTitle, style: AppText.ui(15, weight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 18, 12),
                  child: QMapZoomButtons(controller: _map),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: CircleIconButton(
                    icon: Icons.near_me_outlined,
                    foreground: AppColors.teal,
                    size: 48,
                    shadow: true,
                    tooltip: l10n.myLocation,
                    onPressed: _locate,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: SafeArea(
                    top: false,
                    minimum: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 14,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(2)),
                          ),
                        ),
                        _AddressField(address: address, moved: _moved, onTap: address == null ? null : () => _editAddress(address)),
                        if (outside)
                          _ZoneNote(ok: false, title: l10n.outOfZone, body: l10n.outOfZoneHint)
                        else
                          _ZoneNote(
                            ok: true,
                            title: zone == null ? l10n.inZone : '${l10n.inZone} · ${zone.name}',
                            body: [
                              l10n.zoneInfo(eta, formatTenge(MockData.freeDeliveryFrom)),
                              if (zone != null) l10n.zonePrice(formatTenge(zone.price)),
                            ].join('\n'),
                          ),
                        PillButton(
                          label: l10n.confirmAddress,
                          onPressed: address == null || outside ? null : () => _confirm(address, point),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder map with a drawn zone, for builds without a MapKit key.
class _FallbackMap extends StatelessWidget {
  const _FallbackMap();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: MapPlaceholder(caption: context.l10n.mapStub)),
        Positioned(
          left: 40,
          right: 50,
          top: 150,
          height: 360,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: .14),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(130, 150),
                topRight: Radius.elliptical(170, 210),
                bottomRight: Radius.elliptical(150, 180),
                bottomLeft: Radius.elliptical(120, 150),
              ),
              border: Border.all(color: AppColors.teal, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField({required this.address, required this.moved, required this.onTap});

  final Address? address;
  final bool moved;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final address = this.address;
    final details = [
      if (address != null && address.apartment.isNotEmpty) '${l10n.aptLabel} ${address.apartment}',
      if (address != null && address.floor.isNotEmpty) '${l10n.floor} ${address.floor}',
    ].join(', ');
    return Material(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            spacing: 12,
            children: [
              const Icon(Icons.search_rounded, size: 18, color: AppColors.muted),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(address == null ? '…' : context.tr(address.street), style: AppText.ui(15, weight: FontWeight.w700)),
                    if (moved)
                      Text(
                        l10n.checkStreet,
                        style: AppText.ui(12, weight: FontWeight.w600, color: AppColors.orange),
                      )
                    else if (details.isNotEmpty)
                      Text(details, style: AppText.caption),
                  ],
                ),
              ),
              const Icon(Icons.edit_outlined, size: 18, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

/// Green "in zone" or red "outside the zone" note under the address.
class _ZoneNote extends StatelessWidget {
  const _ZoneNote({required this.ok, required this.title, required this.body});

  final bool ok;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: ok ? AppColors.greenSoft : AppColors.redSoft, borderRadius: BorderRadius.circular(18)),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: ok ? AppColors.green : AppColors.red, shape: BoxShape.circle),
            child: Icon(ok ? Icons.check_rounded : Icons.close_rounded, size: 18, color: AppColors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  title,
                  style: AppText.ui(14, weight: FontWeight.w700, color: ok ? AppColors.greenInk : AppColors.red),
                ),
                Text(
                  body,
                  style: AppText.ui(12, weight: FontWeight.w500, color: ok ? const Color(0xFF3E5A30) : AppColors.inkSoft),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressForm extends StatefulWidget {
  const _AddressForm({required this.initial});

  final Address initial;

  @override
  State<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<_AddressForm> {
  late final _street = TextEditingController(text: widget.initial.street.ru);
  late final _apartment = TextEditingController(text: widget.initial.apartment);
  late final _floor = TextEditingController(text: widget.initial.floor);

  @override
  void initState() {
    super.initState();
    _street.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _street.dispose();
    _apartment.dispose();
    _floor.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppColors.bg,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final valid = _street.text.trim().isNotEmpty;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom + MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(l10n.addresses, style: AppText.title),
          TextField(
            controller: _street,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.streetAddressLine1],
            decoration: _decoration(l10n.street),
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: TextField(controller: _apartment, textInputAction: TextInputAction.next, decoration: _decoration(l10n.aptLabel)),
              ),
              Expanded(
                child: TextField(
                  controller: _floor,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: _decoration(l10n.floor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          PillButton(
            label: l10n.save,
            onPressed: valid
                ? () => Navigator.of(context).pop(
                    Address(street: LocalizedText.same(_street.text.trim()), apartment: _apartment.text.trim(), floor: _floor.text.trim()),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
