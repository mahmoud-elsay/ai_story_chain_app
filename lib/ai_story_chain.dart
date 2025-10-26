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
    return MaterialApp(
      title: 'AI Story Chain',
      theme: _buildTheme(Brightness.light),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Determine if mobile or desktop
            final isMobile = constraints.maxWidth < 1000;

            // Use different design sizes for mobile and desktop
            final designSize = isMobile
                ? const Size(375, 812) // iPhone X design size for mobile
                : const Size(1440, 1024); // Desktop design size

            return ScreenUtilInit(
              designSize: designSize,
              minTextAdapt: true,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0, // Prevent system font scaling
                ),
                child: child!,
              ),
            );
          },
        );
      },
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
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final baseTheme = ThemeData(brightness: brightness);
    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    );
  }
}
