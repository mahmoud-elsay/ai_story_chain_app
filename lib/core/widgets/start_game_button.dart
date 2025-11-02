import 'package:flutter/material.dart';
import 'package:ai_story_chain/core/theming/colors.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// core/widgets/start_game_button.dart

class StartGameButton extends StatelessWidget {
  final bool isGameStarted;
  final bool isHost;
  final VoidCallback onStart;

  const StartGameButton({
    super.key,
    required this.isGameStarted,
    required this.isHost,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    if (isGameStarted || !isHost) return const SizedBox.shrink();

    return ElevatedButton(
      onPressed: onStart,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.mainPurple,
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        'Start Game',
        style: TextStyles.font18WhiteMedium,
      ),
    );
  }
}