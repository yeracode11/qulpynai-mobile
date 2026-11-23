import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/l10n.dart';

/// Renders an [AsyncValue] with a shared loader and error/retry state.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({super.key, required this.value, required this.builder, this.onRetry, this.loadingHeight = 160});

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;
  final double loadingHeight;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: builder,
      loading: () => SizedBox(
        height: loadingHeight,
        child: const Center(child: CircularProgressIndicator(color: AppColors.red, strokeWidth: 2.4)),
      ),
      error: (e, st) => SizedBox(
        height: loadingHeight,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Text(context.l10n.loadError, style: AppText.ui(14)),
              if (onRetry != null) TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows the "stub" snackbar for features that aren't built yet.
void showStub(BuildContext context, [String? message]) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message ?? context.l10n.stub), duration: const Duration(seconds: 2)));
}
