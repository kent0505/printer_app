import 'package:go_router/go_router.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/printer/screens/documents_screen.dart';
import '../../features/printer/screens/email_screen.dart';
import '../../features/printer/screens/photo_screen.dart';
import '../../features/printer/screens/printables_screen.dart';
import '../../features/printer/screens/web_pages_screen.dart';
import '../../features/onboard/screens/onboard_screen.dart';
import '../../features/onboard/screens/splash_screen.dart';
import '../../features/scanner/screens/scanner_screen.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: OnboardScreen.routePath,
      builder: (context, state) => const OnboardScreen(),
    ),
    GoRoute(
      path: HomeScreen.routePath,
      builder: (context, state) => const HomeScreen(),
    ),

    // PRINTER
    GoRoute(
      path: DocumentsScreen.routePath,
      builder: (context, state) => const DocumentsScreen(),
    ),
    GoRoute(
      path: PhotoScreen.routePath,
      builder: (context, state) => const PhotoScreen(),
    ),
    GoRoute(
      path: EmailScreen.routePath,
      builder: (context, state) => const EmailScreen(),
    ),
    GoRoute(
      path: WebPagesScreen.routePath,
      builder: (context, state) => const WebPagesScreen(),
    ),
    GoRoute(
      path: PrintablesScreen.routePath,
      builder: (context, state) => const PrintablesScreen(),
    ),

    // SCANNER
    GoRoute(
      path: ScannerScreen.routePath,
      builder: (context, state) => const ScannerScreen(),
    ),
  ],
);
