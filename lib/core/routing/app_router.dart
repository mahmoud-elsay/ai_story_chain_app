import 'routes.dart';
import 'package:flutter/material.dart';
import 'package:ai_story_chain/desktop/ui/pages/room_page.dart';
import 'package:ai_story_chain/desktop/ui/pages/result_page.dart';
import 'package:ai_story_chain/mobile/ui/screens/room_screen.dart';
import 'package:ai_story_chain/mobile/ui/screens/result_screen.dart';
import 'package:ai_story_chain/desktop/ui/pages/join_room_page.dart';
import 'package:ai_story_chain/desktop/ui/pages/create_room_page.dart';
import 'package:ai_story_chain/mobile/ui/screens/create_room_screen.dart';
import 'package:ai_story_chain/mobile/ui/screens/join_or_create_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.joinOrCreateScreen:
        return MaterialPageRoute(builder: (_) => const JoinOrCreateScreen());
      case Routes.createRoomScreen:
        return MaterialPageRoute(builder: (_) => const CreateRoomScreen());
      case Routes.roomScreen:
        return MaterialPageRoute(builder: (_) => const RoomScreen());
      case Routes.resultScreen:
        return MaterialPageRoute(builder: (_) => const ResultScreen());
      case Routes.joinOrCreateRoomPage:
        return MaterialPageRoute(builder: (_) => const JoinOrCreateRoomPage());
      case Routes.createRoomPage:
        return MaterialPageRoute(builder: (_) => const CreateRoomPage());
      case Routes.roomPage:
        return MaterialPageRoute(builder: (_) => const RoomPage());
      case Routes.resultPage:
        return MaterialPageRoute(builder: (_) => const ResultPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('404 - Page not found'))),
        );
    }
  }
}
