import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/visuals.dart';
import '../../data/providers.dart';

/// 1g — sign in by phone number.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _controller = TextEditingController(text: '707 123 45 67');
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _digits => _controller.text.replaceAll(RegExp(r'\D'), '');

  Future<void> _submit() async {
    setState(() => _sending = true);
    final phone = '+7$_digits';
    await ref.read(authRepositoryProvider).requestCode(phone);
    if (!mounted) return;
    setState(() => _sending = false);
    context.push(Uri(path: '/otp', queryParameters: {'phone': phone}).toString());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: BackCircleButton(background: AppColors.bg),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                children: [
                  const Align(alignment: AlignmentDirectional.centerStart, child: QLogo()),
                  const SizedBox(height: 12),
                  Text(l10n.loginTitle, style: AppText.serif(30, height: 1.2)),
                  const SizedBox(height: 12),
                  Text(
                    l10n.loginText,
                    style: AppText.ui(15, weight: FontWeight.w500, color: AppColors.inkSoft, height: 1.45),
                  ),
                  const SizedBox(height: 32),
                  Text(l10n.phone, style: AppText.ui(13, color: AppColors.muted)),
                  const SizedBox(height: 8),
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, value, _) => Container(
                      height: 60,
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.teal, width: 2),
                      ),
                      child: Row(
                        spacing: 12,
                        children: [
                          Text('+7', style: AppText.num(20, color: AppColors.muted)),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              keyboardType: TextInputType.phone,
                              autofillHints: const [AutofillHints.telephoneNumberNational],
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, _PhoneFormatter()],
                              style: AppText.num(20).copyWith(letterSpacing: .5),
                              decoration: const InputDecoration(border: InputBorder.none, isCollapsed: true, hintText: '700 000 00 00'),
                              onSubmitted: (_) => _digits.length == 10 ? _submit() : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                spacing: 14,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, value, _) =>
                        PillButton(label: l10n.getCode, loading: _sending, onPressed: _digits.length == 10 ? _submit : null),
                  ),
                  Text(
                    l10n.terms,
                    textAlign: TextAlign.center,
                    style: AppText.ui(12, weight: FontWeight.w500, color: AppColors.muted, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formats 10 digits as `707 123 45 67`.
class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final d = newValue.text.replaceAll(RegExp(r'\D'), '');
    final capped = d.length > 10 ? d.substring(0, 10) : d;
    final buf = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i == 3 || i == 6 || i == 8) buf.write(' ');
      buf.write(capped[i]);
    }
    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
