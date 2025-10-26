import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_story_chain/core/routing/routes.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:ai_story_chain/core/theming/colors.dart';
import 'package:ai_story_chain/mobile/ui/widgets/animated_background.dart';
import 'package:ai_story_chain/mobile/ui/widgets/create_room_form.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage>
    with TickerProviderStateMixin {
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

    // Start animations with delay
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

  Future<void> _createRoom(String roomName, String username) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Replace with actual API call
      // final result = await roomService.createRoom(roomName, username);

      // For now, simulate success
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          Routes.roomPage,
          arguments: {
            'roomName': roomName,
            'username': username,
            'roomCode': 'ABC123', // This would come from API
            'isHost': true,
          },
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create room. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          const AnimatedBackground(),

          // Main Content
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Title with Animation
                  AnimatedBuilder(
                    animation: _titleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _titleAnimation.value,
                        child: Opacity(
                          opacity: _titleAnimation.value,
                          child: Column(
                            children: [
                              Text(
                                'AI Story Chain',
                                style: TextStyles.font80WhiteBold.copyWith(
                                  shadows: [
                                    Shadow(
                                      color: ColorsManager.mainPurple
                                          .withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                width: 120.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      ColorsManager.mainPurple,
                                      const Color(0xFF00D4FF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 80.h),

                  // Form with Animation
                  AnimatedBuilder(
                    animation: _formAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, (1 - _formAnimation.value) * 100),
                        child: Opacity(
                          opacity: _formAnimation.value,
                          child: CreateRoomForm(
                            onCreateRoom: _createRoom,
                            isLoading: _isLoading,
                          ),
                        ),
                      );
                    },
                  ),

                  // Error Message
                  if (_errorMessage != null) ...[
                    SizedBox(height: 24.h),
                    AnimatedOpacity(
                      opacity: _errorMessage != null ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20.w,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyles.font16WhiteRegular.copyWith(
                                  color: Colors.red.shade300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 40.h,
            left: 24.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ColorsManager.mainPurple.withOpacity(0.3),
                ),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
