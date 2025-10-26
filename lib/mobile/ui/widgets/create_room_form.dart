import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_story_chain/core/theming/colors.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:ai_story_chain/core/helpers/spacing.dart';

class CreateRoomForm extends StatefulWidget {
  final Function(String roomName, String username) onCreateRoom;
  final bool isLoading;

  const CreateRoomForm({
    super.key,
    required this.onCreateRoom,
    this.isLoading = false,
  });

  @override
  State<CreateRoomForm> createState() => _CreateRoomFormState();
}

class _CreateRoomFormState extends State<CreateRoomForm>
    with TickerProviderStateMixin {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _roomNameFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  bool _isRoomNameValid = false;
  bool _isUsernameValid = false;

  @override
  void initState() {
    super.initState();
    
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _shimmerController.repeat();

    // Generate auto room name
    _generateRoomName();
    
    // Listen to text changes
    _roomNameController.addListener(_onRoomNameChanged);
    _usernameController.addListener(_onUsernameChanged);
  }

  void _generateRoomName() {
    final random = DateTime.now().millisecondsSinceEpoch % 10000;
    _roomNameController.text = 'Room-$random';
    _isRoomNameValid = true;
  }

  void _onRoomNameChanged() {
    setState(() {
      _isRoomNameValid = _roomNameController.text.trim().isNotEmpty;
    });
  }

  void _onUsernameChanged() {
    setState(() {
      _isUsernameValid = _usernameController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _usernameController.dispose();
    _roomNameFocusNode.dispose();
    _usernameFocusNode.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
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
                  'Create Room',
                  style: TextStyles.font48WhiteBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          
          verticalSpace(40),
          
          // Room Name Input
          _buildInputField(
            controller: _roomNameController,
            focusNode: _roomNameFocusNode,
            label: 'Room Name',
            hintText: 'Enter room name',
            icon: Icons.meeting_room_outlined,
            isValid: _isRoomNameValid,
          ),
          
          verticalSpace(24),
          
          // Username Input
          _buildInputField(
            controller: _usernameController,
            focusNode: _usernameFocusNode,
            label: 'Your Name',
            hintText: 'Enter your nickname',
            icon: Icons.person_outline,
            isValid: _isUsernameValid,
          ),
          
          verticalSpace(40),
          
          // Create Room Button
          _buildCreateButton(),
          
          verticalSpace(24),
          
          // Join Existing Room Button
          _buildJoinButton(),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.font18WhiteMedium,
        ),
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
            style: TextStyles.font18WhiteMedium,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyles.font18WhiteMedium.copyWith(
                color: Colors.grey.withOpacity(0.6),
              ),
              prefixIcon: Icon(
                icon,
                color: focusNode.hasFocus
                    ? ColorsManager.mainPurple
                    : Colors.grey.withOpacity(0.6),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    final isEnabled = _isRoomNameValid && _isUsernameValid && !widget.isLoading;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? LinearGradient(
                colors: [
                  ColorsManager.mainPurple,
                  const Color(0xFF00D4FF),
                ],
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
              ? () => widget.onCreateRoom(
                    _roomNameController.text.trim(),
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : Text(
                    'Create Room',
                    style: TextStyles.font20WhiteMedium.copyWith(
                      color: isEnabled ? Colors.white : Colors.grey,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinButton() {
    return TextButton(
      onPressed: widget.isLoading ? null : () {
        // Navigate to join room page
        Navigator.pop(context);
      },
      child: Text(
        'Join Existing Room',
        style: TextStyles.font18WhiteMedium.copyWith(
          color: ColorsManager.mainPurple,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
