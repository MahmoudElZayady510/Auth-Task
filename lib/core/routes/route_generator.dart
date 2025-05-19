import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task/core/routes/routes.dart';
import 'package:task/presentation/auth/screens/reset_password.dart';
import '../../injection_container.dart';
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/auth/screens/signup_screen.dart';
import '../../presentation/discovery/screens/discovery_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final auth = sl<FirebaseAuth>();
    // Check user authentication status
    final isUserAuthenticated = auth.currentUser != null;

    switch (settings.name) {
      case RouteNames.root:
        return MaterialPageRoute(
          builder: (_) =>
              isUserAuthenticated ? DiscoveryScreen() : SignInScreen(),
        );
      case RouteNames.signIn:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case RouteNames.signUp:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case RouteNames.discovery:
        return MaterialPageRoute(
          builder: (_) => DiscoveryScreen(),
        );
       case RouteNames.reset:
         return MaterialPageRoute(
           builder: (_) => ResetPassword(),
         );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
