import 'package:cots/design_system/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../../design_system/layout_tokens.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;

  const CustomInput({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.inputFormatters,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium,
        ),
        SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          validator: validator,
          readOnly: readOnly,
          enabled: enabled,
          inputFormatters: inputFormatters,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.body.copyWith(
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            errorText: errorText,
            errorStyle: AppTypography.error,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    size: AppSpacing.iconSM,
                    color: AppColors.textSecondary,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      suffixIcon,
                      size: AppSpacing.iconSM,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: onSuffixIconPressed,
                  )
                : null,
            filled: true,
            fillColor: enabled ? AppColors.elevated : AppColors.background,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingMD,
              vertical: AppSpacing.paddingMD,
            ),
            border: OutlineInputBorder(
              borderRadius: LayoutTokens.borderRadius,
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: LayoutTokens.borderRadius,
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: LayoutTokens.borderRadius,
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: LayoutTokens.borderRadius,
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: LayoutTokens.borderRadius,
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: LayoutTokens.borderRadius,
              borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}