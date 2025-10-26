import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:ai_story_chain/core/theming/colors.dart';

class AppTitle extends StatelessWidget {
  final TextStyle? titleStyle;
  final String title;
  final double gradientWidth;
  final double gradientHeight;

  const AppTitle({
    super.key,
    this.titleStyle,
    required this.title,
    this.gradientWidth = 80,
    this.gradientHeight = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style:
              titleStyle ??
              TextStyles.font32WhiteBold.copyWith(
                shadows: [
                  Shadow(
                    color: ColorsManager.mainPurple.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: gradientWidth.w,
          height: gradientHeight.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorsManager.mainPurple, const Color(0xFF00D4FF)],
            ),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ],
    );
  }
}
