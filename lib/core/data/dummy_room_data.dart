// core/data/dummy_room_data.dart
// Dummy data for testing and simulation
List<Map<String, String>> dummyStoryChain = [
  {'author': 'AI', 'text': 'Once upon a time in a distant land...'},
  {'author': 'Player1', 'text': 'There lived a brave knight.'},
  {
    'author': 'Player2',
    'text': 'Who embarked on a quest to find the lost treasure.',
  },
];

List<String> dummyPlayers = ['HostUser', 'Player1', 'Player2', 'Player3'];

// Dummy scoring data for demonstration
Map<String, int> dummyScores = {
  'Player1': 280, // Most active player
  'HostUser': 240, // Host with good participation
  'Player2': 220, // Regular contributor
  'Player3': 190, // Less active player
};
