import 'package:flutter/material.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:ai_story_chain/core/helpers/spacing.dart';
import 'package:ai_story_chain/core/widgets/app_title.dart';


class RoomHeader extends StatelessWidget {
  final String roomName;
  final String roomCode;
  final Animation<double> animation;

  const RoomHeader({
    super.key,
    required this.roomName,
    required this.roomCode,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: Column(
              children: [
                AppTitle(title: roomName),
                verticalSpace(8),
                Text(
                  'Code: $roomCode',
                  style: TextStyles.font18WhiteRegular,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}