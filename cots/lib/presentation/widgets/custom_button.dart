import 'package:cots/design_system/appColors.dart';
import 'package:cots/design_system/spacing.dart';
import 'package:flutter/material.dart';
import '../../design_system/typography.dart';
import '../../design_system/layout_tokens.dart';

enum ButtonType { primary, secondary, outlined, text, success, warning, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = isDisabled || isLoading;

    Color backgroundColor;
    Color textColor;
    BorderSide? border;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = disabled ? AppColors.textSecondary.withOpacity(0.3) : AppColors.primary;
        textColor = AppColors.white;
        border = null;
        break;
      case ButtonType.secondary:
        backgroundColor = disabled ? AppColors.textSecondary.withOpacity(0.3) : AppColors.secondary;
        textColor = AppColors.white;
        border = null;
        break;
      case ButtonType.success:
        backgroundColor = disabled ? AppColors.textSecondary.withOpacity(0.3) : AppColors.success;
        textColor = AppColors.white;
        border = null;
        break;
      case ButtonType.warning:
        backgroundColor = disabled ? AppColors.textSecondary.withOpacity(0.3) : AppColors.warning;
        textColor = AppColors.white;
        border = null;
        break;
      case ButtonType.danger:
        backgroundColor = disabled ? AppColors.textSecondary.withOpacity(0.3) : AppColors.danger;
        textColor = AppColors.white;
        border = null;
        break;
      case ButtonType.outlined:
        backgroundColor = Colors.transparent;
        textColor = disabled ? AppColors.textSecondary.withOpacity(0.5) : AppColors.primary;
        border = BorderSide(
          color: disabled ? AppColors.textSecondary.withOpacity(0.3) : AppColors.primary,
          width: 1.5,
        );
        break;
      case ButtonType.text:
        backgroundColor = Colors.transparent;
        textColor = disabled ? AppColors.textSecondary.withOpacity(0.5) : AppColors.primary;
        border = null;
        break;
    }

    return SizedBox(
      width: width,
      height: height ?? LayoutTokens.buttonHeight,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: type == ButtonType.primary || 
                     type == ButtonType.secondary ||
                     type == ButtonType.success ||
                     type == ButtonType.warning ||
                     type == ButtonType.danger
              ? 0
              : 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: LayoutTokens.borderRadius,
            side: border ?? BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingMD,
            vertical: AppSpacing.paddingSM,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: AppSpacing.iconSM,
                height: AppSpacing.iconSM,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppSpacing.iconSM),
                    SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    text,
                    style: AppTypography.button.copyWith(color: textColor),
                  ),
                ],
              ),
      ),
    );
  }
}