import 'package:flutter/material.dart';
import 'package:ai_story_chain/core/theming/colors.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:ai_story_chain/core/helpers/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// core/widgets/story_display.dart

class StoryDisplay extends StatelessWidget {
  final List<Map<String, String>> storyChain;
  final ScrollController scrollController;
  final Animation<double> animation;

  const StoryDisplay({
    super.key,
    required this.storyChain,
    required this.scrollController,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - animation.value) * 50),
          child: Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: ColorsManager.mainPurple.withOpacity(0.3),
                  ),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.w),
                  itemCount: storyChain.length,
                  itemBuilder: (context, index) {
                    final part = storyChain[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${part['author']}: ',
                              style: TextStyles.font16WhiteMedium.copyWith(
                                color: ColorsManager.mainPurple,
                              ),
                            ),
                            TextSpan(
                              text: part['text'],
                              style: TextStyles.font16WhiteRegular,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}