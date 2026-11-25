import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/visuals.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// Story-style promo carousel for the top of the home screen.
///
/// Swipe to change slides, tap to open the promo's link. Slides advance on
/// their own every [slideDuration]; the bar of the current slide fills up as
/// a timer. Holding a finger on the banner pauses it. With "reduce motion"
/// turned on in the system settings, slides don't advance on their own.
class PromoCarousel extends ConsumerStatefulWidget {
  const PromoCarousel({super.key, required this.height, this.textBottomInset = 36});

  final double height;

  /// Space under the title, so text clears whatever overlaps the banner.
  final double textBottomInset;

  static const slideDuration = Duration(seconds: 5);

  @override
  ConsumerState<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends ConsumerState<PromoCarousel> with SingleTickerProviderStateMixin {
  final _pages = PageController();
  late final AnimationController _timer = AnimationController(vsync: this, duration: PromoCarousel.slideDuration)
    ..addStatusListener(_onTimerStatus);
  int _index = 0;
  int _count = 0;

  bool get _autoplay => !MediaQuery.disableAnimationsOf(context);

  void _onTimerStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _count < 2 || !_pages.hasClients) return;
    final next = (_index + 1) % _count;
    if (next == 0) {
      _pages.jumpToPage(0);
    } else {
      _pages.animateToPage(next, duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic);
    }
  }

  void _restartTimer() {
    _timer.reset();
    if (_autoplay && _count > 1) _timer.forward();
  }

  void _pause() => _timer.stop();

  void _resume() {
    if (_autoplay && _count > 1 && !_timer.isAnimating) _timer.forward();
  }

  @override
  void dispose() {
    _timer.dispose();
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final promos = ref.watch(promosProvider).value ?? const <Promo>[];
    if (promos.length != _count) {
      _count = promos.length;
      _index = _index.clamp(0, _count == 0 ? 0 : _count - 1);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _restartTimer();
      });
    }
    if (promos.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const ColoredBox(color: AppColors.teal),
      );
    }
    return SizedBox(
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Listener(
            onPointerDown: (_) => _pause(),
            onPointerUp: (_) => _resume(),
            onPointerCancel: (_) => _resume(),
            child: PageView.builder(
              controller: _pages,
              itemCount: promos.length,
              onPageChanged: (i) {
                setState(() => _index = i);
                _restartTimer();
              },
              itemBuilder: (context, i) =>
                  _Slide(promo: promos[i], onTap: promos[i].link == null ? null : () => context.push(promos[i].link!)),
            ),
          ),
          PositionedDirectional(
            start: 20,
            end: 20,
            bottom: widget.textBottomInset,
            child: IgnorePointer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    layoutBuilder: (current, previous) =>
                        Stack(alignment: AlignmentDirectional.bottomStart, children: [...previous, ?current]),
                    child: _Caption(key: ValueKey(promos[_index].id), promo: promos[_index]),
                  ),
                  if (promos.length > 1) _Bars(count: promos.length, index: _index, progress: _timer, autoplay: _autoplay),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.promo, required this.onTap});

  final Promo promo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: context.tr(promo.title),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: AppColors.teal,
              child: AppImage(src: promo.image, alignment: Alignment(0, promo.imageAlignment)),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x2E000000), Color(0x00000000), Color(0x001F1A17), Color(0xA61F1A17)],
                  stops: [0, .3, .5, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption({super.key, required this.promo});

  final Promo promo;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(context.tr(promo.title), style: AppText.heading(26, color: AppColors.white, height: 1.25)),
          if (promo.subtitle case final subtitle?)
            Text(
              context.tr(subtitle),
              style: AppText.ui(14, weight: FontWeight.w500, color: const Color(0xE6FFFFFF)),
            ),
        ],
      ),
    );
  }
}

/// Story bars: past slides full, current slide filling with the timer.
class _Bars extends StatelessWidget {
  const _Bars({required this.count, required this.index, required this.progress, required this.autoplay});

  final int count;
  final int index;
  final Animation<double> progress;
  final bool autoplay;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        for (var i = 0; i < count; i++)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: SizedBox(
                height: 3,
                child: i == index
                    ? AnimatedBuilder(
                        animation: progress,
                        builder: (_, _) => LinearProgressIndicator(
                          // Without autoplay the timer never runs; show the current bar full.
                          value: autoplay ? progress.value : 1,
                          minHeight: 3,
                          color: AppColors.white,
                          backgroundColor: const Color(0x73FFFFFF),
                        ),
                      )
                    : ColoredBox(color: i < index ? AppColors.white : const Color(0x73FFFFFF)),
              ),
            ),
          ),
      ],
    );
  }
}
