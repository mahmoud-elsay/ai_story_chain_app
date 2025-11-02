import 'package:flutter/material.dart';
import 'package:ai_story_chain/core/theming/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? topPosition;
  final double? leftPosition;
  final bool isMobile;

  const AppBackButton({
    super.key,
    required this.onPressed,
    this.topPosition,
    this.leftPosition,
    this.isMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPosition ?? (isMobile ? 40.h : 40.h),
      left: leftPosition ?? (isMobile ? 24.w : 24.w),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: ColorsManager.mainPurple.withOpacity(0.3),
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20.w,
            ),
          ),
        ),
      ),
    );
  }
}
