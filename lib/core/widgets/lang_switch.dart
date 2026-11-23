import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// RU / KZ toggle. Shown on onboarding and in the profile.
class LangSwitch extends ConsumerWidget {
  const LangSwitch({super.key, this.long = false, this.track = AppColors.bg, this.height = 36});

  /// `Рус / Қаз` instead of `RU / KZ`.
  final bool long;
  final Color track;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(localeProvider).languageCode;
    Widget seg(String lang, String label) {
      final on = code == lang;
      return Semantics(
        selected: on,
        button: true,
        child: GestureDetector(
          onTap: () => ref.read(localeProvider.notifier).set(Locale(lang)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: height - 6,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: on ? AppColors.ink : Colors.transparent, borderRadius: BorderRadius.circular(height)),
            child: Text(
              label,
              style: AppText.ui(long ? 12 : 13, weight: FontWeight.w700, color: on ? AppColors.white : AppColors.muted),
            ),
          ),
        ),
      );
    }

    return Container(
      height: height,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: track, borderRadius: BorderRadius.circular(height / 2)),
      child: Row(mainAxisSize: MainAxisSize.min, spacing: 2, children: [seg('ru', long ? 'Рус' : 'RU'), seg('kk', long ? 'Қаз' : 'KZ')]),
    );
  }
}

/// Compact `РУС` / `ҚАЗ` badge; tapping cycles the language.
class LangBadge extends ConsumerWidget {
  const LangBadge({super.key, this.height = 44, this.background = AppColors.white, this.border});

  final double height;
  final Color background;
  final Color? border;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kk = ref.watch(localeProvider).languageCode == 'kk';
    return Material(
      color: background,
      shape: StadiumBorder(side: border == null ? BorderSide.none : BorderSide(color: border!)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => ref.read(localeProvider.notifier).set(Locale(kk ? 'ru' : 'kk')),
        child: Container(
          height: height,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
          alignment: Alignment.center,
          child: Text(kk ? 'ҚАЗ' : 'РУС', style: AppText.ui(13, weight: FontWeight.w700)),
        ),
      ),
    );
  }
}
