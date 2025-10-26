import 'core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mobile/ui/screens/create_room_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_story_chain/desktop/ui/pages/create_room_page.dart';

class AiStoryChainApp extends StatelessWidget {
  final AppRouter appRouter;
  const AiStoryChainApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'AI Story Chain',
        theme: _buildTheme(Brightness.light),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.generateRoute,
        home: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 1000) {
              return const CreateRoomScreen();
            } else {
              return const CreateRoomPage();
            }
          },
        ),
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final baseTheme = ThemeData(brightness: brightness);
    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    );
  }
}
