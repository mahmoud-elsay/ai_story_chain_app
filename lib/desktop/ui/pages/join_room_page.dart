import 'package:flutter/material.dart';
import 'package:ai_story_chain/core/routing/routes.dart';
import 'package:ai_story_chain/core/helpers/spacing.dart';
import 'package:ai_story_chain/core/helpers/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_story_chain/core/widgets/app_title.dart';
import 'package:ai_story_chain/core/widgets/error_message.dart';
import 'package:ai_story_chain/core/widgets/app_back_button.dart';
import 'package:ai_story_chain/core/widgets/animated_background.dart';
import 'package:ai_story_chain/mobile/ui/widgets/join_room_form.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleAnimation;
  late Animation<double> _formAnimation;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _formAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _joinRoom(String roomCode, String username) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        context.pushReplacementNamed(
          Routes
              .roomPage, // Routes.roomPage will resolve to RoomPage or RoomScreen
          arguments: {
            'roomCode': roomCode,
            'username': username,
            'isHost': false,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to join room. Please check the room code.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _titleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _titleAnimation.value,
                        child: Opacity(
                          opacity: _titleAnimation.value.clamp(0.0, 1.0),
                          child: const AppTitle(
                            title: 'AI Story Chain',
                            gradientWidth: 120,
                            gradientHeight: 5,
                          ),
                        ),
                      );
                    },
                  ),
                  verticalSpace(80),
                  AnimatedBuilder(
                    animation: _formAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, (1 - _formAnimation.value) * 100),
                        child: Opacity(
                          opacity: _formAnimation.value.clamp(0.0, 1.0),
                          child: JoinRoomForm(
                            onJoinRoom: _joinRoom,
                            isLoading: _isLoading,
                          ),
                        ),
                      );
                    },
                  ),
                  if (_errorMessage != null) ...[
                    verticalSpace(24),
                    ErrorMessage(message: _errorMessage!),
                  ],
                ],
              ),
            ),
          ),
          AppBackButton(onPressed: () => context.pop(), isMobile: false),
        ],
      ),
    );
  }
}
