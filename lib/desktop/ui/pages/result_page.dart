import 'package:flutter/material.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:ai_story_chain/core/theming/colors.dart';
import 'package:ai_story_chain/core/helpers/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_story_chain/core/widgets/animated_background.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic>? args;

  const ResultPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> scores = Map<String, int>.from(
      args?['scores'] ?? {},
    );
    final String roomName = args?['roomName'] ?? 'Unknown Room';

    // Sort players by score in descending order
    final sortedPlayers = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Text(
                        'Story Complete!',
                        style: TextStyles.font36WhiteMedium,
                        textAlign: TextAlign.center,
                      ),
                      verticalSpace(8),
                      Text(
                        roomName,
                        style: TextStyles.font24WhiteMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(24.w),
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Leaderboard',
                          style: TextStyles.font24WhiteMedium,
                          textAlign: TextAlign.center,
                        ),
                        verticalSpace(24),
                        Expanded(
                          child: ListView.builder(
                            itemCount: sortedPlayers.length,
                            itemBuilder: (context, index) {
                              final player = sortedPlayers[index];
                              final isWinner = index == 0;

                              return Container(
                                margin: EdgeInsets.only(bottom: 16.h),
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: isWinner
                                      ? ColorsManager.mainPurple.withOpacity(
                                          0.3,
                                        )
                                      : Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: isWinner
                                      ? Border.all(
                                          color: ColorsManager.mainPurple,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36.w,
                                      height: 36.w,
                                      decoration: BoxDecoration(
                                        color: isWinner
                                            ? ColorsManager.mainPurple
                                            : Colors.white.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyles.font18WhiteMedium,
                                        ),
                                      ),
                                    ),
                                    horizontalSpace(16),
                                    Expanded(
                                      child: Text(
                                        player.key,
                                        style: TextStyles.font18WhiteMedium,
                                      ),
                                    ),
                                    Text(
                                      '${player.value} pts',
                                      style: TextStyles.font18WhiteMedium
                                          .copyWith(
                                            color: isWinner
                                                ? ColorsManager.mainPurple
                                                : Colors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
