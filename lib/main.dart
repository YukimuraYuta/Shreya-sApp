import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';
import 'registration_page.dart'; // New import

void main() {
  runApp(const RideFlowApp());
}

class RideFlowApp extends StatelessWidget {
  const RideFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RideFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFFC107),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFC107),
          secondary: Color(0xFFFFD54F),
          surface: Color(0xFF1E1E1E),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      // Custom transition for smooth page navigation
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());
          case '/login':
            return _createRoute(const LoginScreen());
          case '/register': // New Route for Registration
            return _createRoute(const RegistrationPage());
          default:
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());
        }
      },
    );
  }

  // Original smooth slide-up transition effect
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutQuart;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
