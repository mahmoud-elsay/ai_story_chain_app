import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ai_story_chain/core/routing/routes.dart';
import 'package:ai_story_chain/core/theming/styles.dart';
import 'package:ai_story_chain/core/helpers/spacing.dart';
import 'package:ai_story_chain/core/helpers/extension.dart';
import 'package:ai_story_chain/core/widgets/room_header.dart';
import 'package:ai_story_chain/core/widgets/players_list.dart';
import 'package:ai_story_chain/core/data/dummy_room_data.dart';
import 'package:ai_story_chain/core/widgets/error_message.dart';
import 'package:ai_story_chain/core/widgets/story_display.dart';
import 'package:ai_story_chain/core/widgets/app_back_button.dart';
import 'package:ai_story_chain/core/widgets/story_input_area.dart';
import 'package:ai_story_chain/core/widgets/start_game_button.dart';
import 'package:ai_story_chain/core/widgets/animated_background.dart';

class RoomScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  const RoomScreen({super.key, this.args});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleAnimation;
  late Animation<double> _contentAnimation;

  late String roomName;
  late String username;
  late String roomCode;
  late bool isHost;

  List<String> players = [];
  List<Map<String, String>> storyChain = [];
  Map<String, int> playerScores = {};
  int currentTurnIndex = 0;
  int currentRound = 0;
  int totalRounds = 3;
  bool isGameStarted = false;
  bool isLoading = false;
  String? errorMessage;

  final TextEditingController _storyController = TextEditingController();
  final ScrollController _storyScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final args = widget.args;
    print('RoomScreen args: $args'); // Debug print
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
      currentRound = 1;
      storyChain.clear();
      players.forEach((player) => playerScores[player] = 0);
      _addToStory(
        'AI',
        'Round $currentRound: Once upon a time in a distant land...',
      );
    });
  }

  void _endRound() {
    // Calculate scores for the round
    players.forEach((player) {
      final contributions = storyChain.where(
        (entry) => entry['author'] == player,
      );
      final roundScore =
          contributions.length *
          10; // Basic scoring: 10 points per contribution
      playerScores[player] = (playerScores[player] ?? 0) + roundScore;
    });

    if (currentRound < totalRounds) {
      setState(() {
        currentRound++;
        storyChain.clear();
        currentTurnIndex = 0;
        _addToStory('AI', 'Round $currentRound: A new chapter begins...');
      });
    } else {
      _endGame();
    }
  }

  void _endGame() {
    // For demonstration, merge player scores with dummy scores
    final Map<String, int> finalScores = Map.from(dummyScores);
    playerScores.forEach((player, score) {
      finalScores[player] = (finalScores[player] ?? 0) + score;
    });

    // Add some random bonus points for variety (0-50 points)
    final random = Random();
    finalScores.forEach((player, score) {
      finalScores[player] = score + random.nextInt(50);
    });

    // Navigate to result screen with scores
    context.pushReplacementNamed(
      Routes.resultScreen,
      arguments: {'scores': finalScores, 'roomName': roomName},
    );
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

      // Check if we completed a round (all players have contributed)
      if (currentTurnIndex == 0) {
        _endRound();
      } else if (players[currentTurnIndex] != username) {
        _simulateOtherTurn();
      }
    });
  }

  bool get isMyTurn => isGameStarted && players[currentTurnIndex] == username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensure UI resizes to avoid keyboard
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    RoomHeader(
                      roomName: roomName,
                      roomCode: roomCode,
                      animation: _titleAnimation,
                    ),
                    verticalSpace(24),
                    if (isGameStarted) ...[
                      Text(
                        'Round $currentRound of $totalRounds',
                        style: TextStyles.font24WhiteMedium,
                        textAlign: TextAlign.center,
                      ),
                      verticalSpace(16),
                    ],
                    PlayersList(
                      players: players,
                      username: username,
                      animation: _contentAnimation,
                    ),
                    verticalSpace(24),
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.height *
                          0.5, // Flexible height for StoryDisplay
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
            ),
          ),
          AppBackButton(onPressed: () => context.pop(), isMobile: true),
        ],
      ),
    );
  }
}
