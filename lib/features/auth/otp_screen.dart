import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/visuals.dart';
import '../../data/providers.dart';

/// 1h — 4-digit SMS code. Mock accepts `1234`.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _length = 4;
  static const _resendSeconds = 42;

  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _secondsLeft = _resendSeconds;
  bool _error = false;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = _resendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      if (_secondsLeft <= 1) t.cancel();
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _onChanged(String value) async {
    setState(() => _error = false);
    if (value.length < _length) return;
    setState(() => _checking = true);
    final ok = await ref.read(authRepositoryProvider).verifyCode(widget.phone, value);
    if (!mounted) return;
    setState(() {
      _checking = false;
      _error = !ok;
    });
    if (ok) {
      context.go('/home');
    } else {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final code = _controller.text;
    final time = '0:${_secondsLeft.toString().padLeft(2, '0')}';
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: BackCircleButton(background: AppColors.bg),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 28, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.otpTitle, style: AppText.heading(30, height: 1.2)),
                  const SizedBox(height: 12),
                  Text(
                    l10n.otpSent(formatPhone(widget.phone)),
                    style: AppText.ui(15, weight: FontWeight.w500, color: AppColors.inkSoft, height: 1.45),
                  ),
                  const SizedBox(height: 24),
                  // Hidden field drives the four boxes; tapping the boxes focuses it.
                  GestureDetector(
                    onTap: () => _focus.requestFocus(),
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0,
                          child: SizedBox(
                            height: 72,
                            child: TextField(
                              controller: _controller,
                              focusNode: _focus,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              maxLength: _length,
                              enabled: !_checking,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: _onChanged,
                            ),
                          ),
                        ),
                        Row(spacing: 12, children: [for (var i = 0; i < _length; i++) Expanded(child: _box(i, code))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_error)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(l10n.otpWrong, style: AppText.ui(13, color: AppColors.redDark)),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: _secondsLeft > 0
                            ? Text(l10n.resendIn(time), style: AppText.ui(14, color: AppColors.muted))
                            : Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: TextLink(label: l10n.resend, color: AppColors.tealDark, onPressed: () => setState(_startTimer)),
                              ),
                      ),
                      TextLink(label: l10n.changeNumber, onPressed: () => context.pop()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.otpHint,
                    style: AppText.ui(12, weight: FontWeight.w500, color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(int i, String code) {
    final filled = i < code.length;
    final active = i == code.length && _focus.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppColors.white : AppColors.bg,
        borderRadius: BorderRadius.circular(20),
        border: active
            ? Border.all(color: AppColors.teal, width: 2)
            : _error
            ? Border.all(color: AppColors.red, width: 2)
            : null,
      ),
      child: filled
          ? Text(code[i], style: AppText.num(30))
          : active
          ? Container(width: 2, height: 30, color: AppColors.teal)
          : null,
    );
  }
}
