import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/lang_switch.dart';
import '../../core/widgets/visuals.dart';

/// 1f — onboarding with language choice.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Only one slide is designed so far; the dots show the planned three.
  final int _page = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 470 + top - 54,
            child: Container(
              color: AppColors.teal,
              child: Image.asset(
                'assets/images/baganashil.png',
                fit: BoxFit.cover,
                alignment: const Alignment(0.24, 1),
                excludeFromSemantics: true,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 140,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x8C005A5A), Color(0x00005A5A)],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const LangSwitch(track: Color(0xF2FFFFFF), height: 40),
                    Material(
                      color: const Color(0xF2FFFFFF),
                      shape: const StadiumBorder(),
                      child: InkWell(
                        customBorder: const StadiumBorder(),
                        onTap: () => context.go('/home'),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          child: Text(l10n.skip, style: AppText.ui(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 440 + top - 54,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QLogo(semanticLabel: l10n.appTitle),
                    const SizedBox(height: 14),
                    Text(l10n.onbTitle, style: AppText.serif(30, height: 1.2)),
                    const SizedBox(height: 14),
                    Text(
                      l10n.onbText,
                      style: AppText.ui(15, weight: FontWeight.w500, color: AppColors.inkSoft, height: 1.45),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      spacing: 6,
                      children: [
                        for (var i = 0; i < 3; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: i == _page ? 24 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _page ? AppColors.red : AppColors.line,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    PillButton(label: l10n.start, onPressed: () => context.push('/login')),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
