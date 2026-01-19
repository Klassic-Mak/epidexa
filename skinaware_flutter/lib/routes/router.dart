import 'package:flutter/material.dart';
import 'package:skinaware_flutter/mainpage.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';
import 'package:skinaware_flutter/screens/profileScreen/profile_screen.dart';
import 'package:skinaware_flutter/screens/model_test_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  print("Routing to: ${settings.name}");

  switch (settings.name) {
    case mainPageRoute:
      return _RightSlide(Mainpage());

    case profilePageRoute:
      return _RightSlide(ProfileScreen());

    case modelTestRoute:
      return _RightSlide(const ModelTestScreen());

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('Page not found')),
        ),
      );
  }
}

Route _RightSlide(Widget child) {
  return PageRouteBuilder(
    // Page builder remains the same
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;

      // Maintain the easing curve
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
