import 'package:flutter/material.dart';
import 'package:ai_story_chain/core/theming/colors.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:ai_story_chain/core/helpers/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// core/widgets/story_input_area.dart

class StoryInputArea extends StatelessWidget {
  final bool isGameStarted;
  final bool isMyTurn;
  final bool isLoading;
  final String currentPlayer;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final Animation<double> animation;

  const StoryInputArea({
    super.key,
    required this.isGameStarted,
    required this.isMyTurn,
    required this.isLoading,
    required this.currentPlayer,
    required this.controller,
    required this.onSubmit,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    if (!isGameStarted) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - animation.value) * 50),
          child: Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  if (!isMyTurn)
                    Text(
                      'Waiting for $currentPlayer...',
                      style: TextStyles.font18WhiteRegular,
                    ),
                  if (isMyTurn) ...[
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Add your part to the story...',
                        hintStyle: TextStyles.font16WhiteRegular.copyWith(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: ColorsManager.mainPurple),
                        ),
                      ),
                      style: TextStyles.font16WhiteRegular,
                      maxLines: 3,
                    ),
                    verticalSpace(16),
                    ElevatedButton(
                      onPressed: isLoading ? null : onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.mainPurple,
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Submit',
                              style: TextStyles.font18WhiteMedium,
                            ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}