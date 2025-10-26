import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_story_chain/core/theming/styles.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final double verticalSpacing;

  const ErrorMessage({
    super.key,
    required this.message,
    this.verticalSpacing = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: verticalSpacing.h,
      child: AnimatedOpacity(
        opacity: message.isNotEmpty ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 20.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyles.font16WhiteRegular.copyWith(
                    color: Colors.red.shade300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
