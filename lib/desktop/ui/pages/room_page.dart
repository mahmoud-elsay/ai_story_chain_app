import 'package:flutter/material.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:ai_story_chain/core/helpers/spacing.dart';
import 'package:ai_story_chain/core/helpers/extension.dart';
import 'package:ai_story_chain/core/widgets/room_header.dart';
import 'package:ai_story_chain/core/widgets/players_list.dart';
import 'package:ai_story_chain/core/widgets/error_message.dart';
import 'package:ai_story_chain/core/widgets/story_display.dart';
import 'package:ai_story_chain/core/widgets/app_back_button.dart';
import 'package:ai_story_chain/core/widgets/story_input_area.dart';
import 'package:ai_story_chain/core/widgets/start_game_button.dart';
import 'package:ai_story_chain/core/widgets/animated_background.dart';

class RoomPage extends StatefulWidget {
  final Map<String, dynamic>? args;

  const RoomPage({super.key, this.args});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleAnimation;
  late Animation<double> _contentAnimation;

  late String roomName;
  late String username;
  late String roomCode;
  late bool isHost;

  List<String> players = [];
  List<Map<String, String>> storyChain = [];
  int currentTurnIndex = 0;
  bool isGameStarted = false;
  bool isLoading = false;
  String? errorMessage;

  final TextEditingController _storyController = TextEditingController();
  final ScrollController _storyScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final args = widget.args;
    print('RoomPage args: $args'); // Debug print
    roomName = args?['roomName'] ?? 'Unnamed Room';
    username = args?['username'] ?? 'Guest';
    roomCode = args?['roomCode'] ?? 'XXXXXX';
    isHost = args?['isHost'] ?? false;

    players = [username];
    if (!isHost) {
      players.add('HostUser');
    }
    players.addAll(['Player2', 'Player3']);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _contentAnimation = Tween<double>(
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
    _storyController.dispose();
    _storyScrollController.dispose();
    super.dispose();
  }

  void _startGame() {
    if (!mounted) return;
    setState(() {
      isGameStarted = true;
      currentTurnIndex = 0;
      storyChain.clear();
      _addToStory('AI', 'Once upon a time in a distant land...');
    });
  }

  void _addToStory(String author, String text) {
    if (!mounted) return;
    setState(() {
      storyChain.add({'author': author, 'text': text});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_storyScrollController.hasClients) {
        _storyScrollController.animateTo(
          _storyScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _submitStory() {
    if (!mounted || _storyController.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      _addToStory(username, _storyController.text);
      _storyController.clear();

      currentTurnIndex = (currentTurnIndex + 1) % players.length;

      if (players[currentTurnIndex] != username) {
        _simulateOtherTurn();
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  void _simulateOtherTurn() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final dummyText = 'And then, something unexpected happened...';
      _addToStory(players[currentTurnIndex], dummyText);

      currentTurnIndex = (currentTurnIndex + 1) % players.length;
      setState(() {});

      if (players[currentTurnIndex] != username) {
        _simulateOtherTurn();
      }
    });
  }

  bool get isMyTurn => isGameStarted && players[currentTurnIndex] == username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RepaintBoundary(child: const AnimatedBackground()),

          SafeArea(
            child: Column(
              children: [
                RoomHeader(
                  roomName: roomName,
                  roomCode: roomCode,
                  animation: _titleAnimation,
                ),

                verticalSpace(24),

                PlayersList(
                  players: players,
                  username: username,
                  animation: _contentAnimation,
                ),

                verticalSpace(24),

                Expanded(
                  child: StoryDisplay(
                    storyChain: storyChain,
                    scrollController: _storyScrollController,
                    animation: _contentAnimation,
                  ),
                ),

                if (errorMessage != null) ...[
                  verticalSpace(16),
                  ErrorMessage(message: errorMessage!),
                ],

                verticalSpace(16),

                if (!isGameStarted && !isHost)
                  Text(
                    'Waiting for host to start the game...',
                    style: TextStyles.font18WhiteRegular,
                  ),

                StoryInputArea(
                  isGameStarted: isGameStarted,
                  isMyTurn: isMyTurn,
                  isLoading: isLoading,
                  currentPlayer: players.length > currentTurnIndex
                      ? players[currentTurnIndex]
                      : '',
                  controller: _storyController,
                  onSubmit: _submitStory,
                  animation: _contentAnimation,
                ),

                StartGameButton(
                  isGameStarted: isGameStarted,
                  isHost: isHost,
                  onStart: _startGame,
                ),

                verticalSpace(24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
