import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_story_chain/core/routing/routes.dart';
import 'package:ai_story_chain/core/widgets/animated_background.dart';
import 'package:ai_story_chain/core/widgets/app_title.dart';
import 'package:ai_story_chain/core/widgets/app_back_button.dart';
import 'package:ai_story_chain/core/widgets/error_message.dart';
import 'package:ai_story_chain/core/helpers/spacing.dart';
import 'package:ai_story_chain/mobile/ui/widgets/join_room_form.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _formController;
  late Animation<double> _titleAnimation;
  late Animation<double> _formAnimation;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.elasticOut),
    );

    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutBack),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _titleController.forward();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _formController.dispose();
    super.dispose();
  }

  Future<void> _joinRoom(String roomCode, String username) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          Routes.roomScreen,
          arguments: {
            'roomCode': roomCode,
            'username': username,
            'isHost': false,
          },
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to join room. Please check the room code.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(child: const AnimatedBackground()),

          SafeArea(
            child: Center(
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
                            child: const AppTitle(title: 'AI Story Chain'),
                          ),
                        );
                      },
                    ),

                    verticalSpace(40),

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
                      verticalSpace(16),
                      ErrorMessage(message: _errorMessage!),
                    ],
                  ],
                ),
              ),
            ),
          ),

          AppBackButton(
            onPressed: () => Navigator.pop(context),
            isMobile: true,
          ),
        ],
      ),
    );
  }
}
