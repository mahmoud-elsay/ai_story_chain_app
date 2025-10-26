import 'package:flutter/material.dart';
import 'package:ai_story_chain/core/theming/colors.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextButton extends StatelessWidget {
  final String textButton;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? borderRadius;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? buttonPadding;
  final bool enabled;
  final bool isLoading;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;

  const AppTextButton({
    super.key,
    this.enabled = true,
    required this.onPressed,
    required this.textButton,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.width,
    this.height,
    this.fontSize,
    this.borderRadius,
    this.fontWeight,
    this.padding,
    this.buttonPadding,
    this.isLoading = false,
    this.gradient,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && !isLoading && onPressed != null;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: isEnabled
              ? (gradient ??
                    LinearGradient(
                      colors: [
                        ColorsManager.mainPurple,
                        const Color(0xFF00D4FF),
                      ],
                    ))
              : LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(0.3),
                    Colors.grey.withOpacity(0.2),
                  ],
                ),
          borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
          boxShadow: isEnabled
              ? (boxShadow ??
                    [
                      BoxShadow(
                        color: ColorsManager.mainPurple.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ])
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
            child: Container(
              padding: padding ?? EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            textColor ?? Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        textButton,
                        style: TextStyles.font18WhiteMedium.copyWith(
                          color: isEnabled
                              ? (textColor ?? Colors.white)
                              : (disabledTextColor ?? Colors.grey),
                          fontSize: fontSize ?? 18.sp,
                          fontWeight: fontWeight ?? FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
