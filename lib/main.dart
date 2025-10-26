import 'core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:ai_story_chain/ai_story_chain.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AiStoryChainApp(appRouter: AppRouter()));
}
