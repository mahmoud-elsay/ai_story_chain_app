import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_story_chain/core/theming/colors.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:ai_story_chain/core/helpers/spacing.dart';
import 'package:ai_story_chain/core/routing/routes.dart';

class JoinRoomForm extends StatefulWidget {
  final Function(String roomCode, String username) onJoinRoom;
  final bool isLoading;

  const JoinRoomForm({
    super.key,
    required this.onJoinRoom,
    this.isLoading = false,
  });

  @override
  State<JoinRoomForm> createState() => _JoinRoomFormState();
}

class _JoinRoomFormState extends State<JoinRoomForm>
    with TickerProviderStateMixin {
  final TextEditingController _roomCodeController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _roomCodeFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  bool _isRoomCodeValid = false;
  bool _isUsernameValid = false;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _shimmerController.repeat();

    // Listen to text changes
    _roomCodeController.addListener(_onRoomCodeChanged);
    _usernameController.addListener(_onUsernameChanged);
  }

  void _onRoomCodeChanged() {
    setState(() {
      _isRoomCodeValid = _roomCodeController.text.trim().length >= 4;
    });
  }

  void _onUsernameChanged() {
    setState(() {
      _isUsernameValid = _usernameController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _roomCodeController.dispose();
    _usernameController.dispose();
    _roomCodeFocusNode.dispose();
    _usernameFocusNode.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: ColorsManager.mainPurple.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.mainPurple.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title with shimmer effect
          AnimatedBuilder(
            animation: _shimmerAnimation,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      ColorsManager.mainPurple,
                      const Color(0xFF00D4FF),
                      ColorsManager.mainPurple,
                    ],
                    stops: [
                      _shimmerAnimation.value - 0.3,
                      _shimmerAnimation.value,
                      _shimmerAnimation.value + 0.3,
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  'Join Room',
                  style: TextStyles.font24WhiteBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          verticalSpace(20),

          // Room Code Input
          _buildInputField(
            controller: _roomCodeController,
            focusNode: _roomCodeFocusNode,
            label: 'Room Code',
            hintText: 'Enter 4-digit room code',
            icon: Icons.qr_code_scanner_outlined,
            isValid: _isRoomCodeValid,
            maxLength: 4,
          ),

          verticalSpace(16),

          // Username Input
          _buildInputField(
            controller: _usernameController,
            focusNode: _usernameFocusNode,
            label: 'Your Name',
            hintText: 'Enter your nickname',
            icon: Icons.person_outline,
            isValid: _isUsernameValid,
          ),

          verticalSpace(24),

          // Join Room Button
          _buildJoinButton(),

          verticalSpace(16),

          // Create New Room Button
          _buildCreateButton(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hintText,
    required IconData icon,
    required bool isValid,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyles.font14WhiteMedium),
        verticalSpace(8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.2),
              ],
            ),
            border: Border.all(
              color: focusNode.hasFocus
                  ? ColorsManager.mainPurple
                  : isValid
                  ? ColorsManager.mainPurple.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.3),
              width: focusNode.hasFocus ? 2 : 1,
            ),
            boxShadow: focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: ColorsManager.mainPurple.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: TextStyles.font16WhiteMedium,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyles.font16WhiteMedium.copyWith(
                color: Colors.grey.withOpacity(0.6),
              ),
              counterText: '',
              prefixIcon: Icon(
                icon,
                color: focusNode.hasFocus
                    ? ColorsManager.mainPurple
                    : Colors.grey.withOpacity(0.6),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJoinButton() {
    final isEnabled = _isRoomCodeValid && _isUsernameValid && !widget.isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? LinearGradient(
                colors: [ColorsManager.mainPurple, const Color(0xFF00D4FF)],
              )
            : LinearGradient(
                colors: [
                  Colors.grey.withOpacity(0.3),
                  Colors.grey.withOpacity(0.2),
                ],
              ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: ColorsManager.mainPurple.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled
              ? () => widget.onJoinRoom(
                  _roomCodeController.text.trim(),
                  _usernameController.text.trim(),
                )
              : null,
          borderRadius: BorderRadius.circular(16.r),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Join Room',
                    style: TextStyles.font18WhiteMedium.copyWith(
                      color: isEnabled ? Colors.white : Colors.grey,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return TextButton(
      onPressed: widget.isLoading
          ? null
          : () {
              Navigator.pushReplacementNamed(context, Routes.createRoomScreen);
            },
      child: Text(
        'Create New Room',
        style: TextStyles.font16WhiteMedium.copyWith(
          color: ColorsManager.mainPurple,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
