import 'package:flutter/material.dart';
import 'package:ai_story_chain/core/theming/colors.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:ai_story_chain/core/helpers/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// core/widgets/players_list.dart

class PlayersList extends StatelessWidget {
  final List<String> players;
  final String username;
  final Animation<double> animation;

  const PlayersList({
    super.key,
    required this.players,
    required this.username,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Players (${players.length}):',
                    style: TextStyles.font20WhiteMedium,
                  ),
                  verticalSpace(8),
                  Wrap(
                    spacing: 8.w,
                    children: players.map((player) => Chip(
                      label: Text(
                        player,
                        style: TextStyles.font14WhiteMedium,
                      ),
                      backgroundColor: player == username
                          ? ColorsManager.mainPurple
                          : Colors.black.withOpacity(0.3),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}