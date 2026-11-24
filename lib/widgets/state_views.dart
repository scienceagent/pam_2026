import 'package:flutter/material.dart';
import 'package:test_pam/resources/app_colors.dart';
import 'package:test_pam/resources/app_strings.dart';
import 'package:test_pam/resources/app_text_styles.dart';

// Vederile pentru stările Loading (spinner), Error (mesaj + Retry) și Empty (mesaj + Reset).
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      Center(child: CircularProgressIndicator(color: AppColors.coralGreen01));
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.black03),
            SizedBox(height: 12),
            Text(message, style: AppTextStyles.regular14.copyWith(color: AppColors.black01), textAlign: TextAlign.center),
            SizedBox(height: 16),
            _ActionButton(label: AppStrings.retry, onTap: onRetry),
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.message, this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 40, color: AppColors.grey01),
          SizedBox(height: 8),
          Text(message, style: AppTextStyles.medium14, textAlign: TextAlign.center),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: 12),
            _ActionButton(label: actionLabel!, onTap: onAction!),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.coralGreen01,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(label, style: AppTextStyles.semiBold14.copyWith(color: AppColors.whiteColor)),
        ),
      ),
    );
  }
}
