import 'package:flutter/material.dart';
import 'package:skinaware_flutter/mainpage.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';
import 'package:skinaware_flutter/screens/auths/login_screen.dart';
import 'package:skinaware_flutter/screens/auths/signup_screen.dart';
import 'package:skinaware_flutter/screens/check_symtopms_screen/check_sys_screen.dart';
import 'package:skinaware_flutter/screens/onboarding_screen.dart';
import 'package:skinaware_flutter/screens/profileScreen/profile_screen.dart';
import 'package:skinaware_flutter/screens/scan_screen.dart' show ScanScreen;
import 'package:skinaware_flutter/screens/settings_screen.dart';
// import 'package:skinaware_flutter/screens/model_test_screen.dart';  // DISABLED - PyTorch not in use
import 'package:skinaware_flutter/screens/skin_camera_screen.dart';
import 'package:skinaware_flutter/screens/chat/chat_screen.dart';
import 'package:skinaware_flutter/screens/analysis/analysis_result_screen.dart';
import 'package:skinaware_flutter/screens/analysis/offline_analysis_result_screen.dart';
import 'package:skinaware_flutter/services/ai/ollama_service.dart';
import 'package:skinaware_flutter/services/tflite_inference_service.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case mainPageRoute:
      return _RightSlide(Mainpage());

    case profilePageRoute:
      return _RightSlide(SettingsScreen());

    case settingsRoute:
      return _RightSlide(const SettingsScreen());

    case scanRoute:
      return _RightSlide(const ScanScreen());

    case checkSymRoute:
      return _RightSlide(const CheckSkinScreen());

    case onBoarding1Route:
      return _RightSlide(
        OnboardingScreen(),
      );
    case profileRoute:
      return _RightSlide(ProfileScreen());

    case loginRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());

    case signupRoute:
      return _RightSlide(SignupScreen());

    case camerScanRoute:
      return _RightSlide(const SkinCameraScreen());
    case chatRoute:
      return _RightSlide(const ChatScreen());

    case analysisResultRoute:
      final args = settings.arguments as Map<String, dynamic>;
      return _RightSlide(
        AnalysisResultScreen(
          imagePath: args['imagePath'] as String,
          result: args['result'] as AnalysisResult?,
        ),
      );

    case offlineAnalysisResultRoute:
      final args = settings.arguments as Map<String, dynamic>;
      return _RightSlide(
        OfflineAnalysisResultScreen(
          imagePath: args['imagePath'] as String,
          result: args['result'] as OfflineAnalysisResult,
        ),
      );

    case onBoardingRoute:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('Onboarding Screen 1')),
        ),
      );
    case modelTestRoute:
      // return _RightSlide(const ModelTestScreen());  // DISABLED - PyTorch model not in use
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Model Test')),
          body: const Center(
            child: Text('PyTorch model testing is disabled.\nUsing Ollama AI instead.'),
          ),
        ),
      );

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
