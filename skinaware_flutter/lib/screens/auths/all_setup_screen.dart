import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfileCompletedScreen extends StatelessWidget {
  const ProfileCompletedScreen({
    super.key,
    required this.onGoToExpidexa,
  });

  final VoidCallback onGoToExpidexa;

  static const Color primaryColor = Color(0xFF0284C7);
  static const Color pageBg = Color(0xFFF7F8FC);

  static const String lottieUrl =
      "https://assets10.lottiefiles.com/packages/lf20_jbrw3hcz.json";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
          child: Column(
            children: [
              const Spacer(),

              // Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE8EEF6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ✅ Lottie from network
                    SizedBox(
                      height: 190,
                      child: Lottie.network(
                        lottieUrl,
                        repeat: false,
                        fit: BoxFit.contain,
                        frameRate: FrameRate.max,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.check_circle_rounded,
                            size: 90,
                            color: Colors.green,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "You're all set!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Your profile has been completed successfully. You can now continue to Expidexa.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onGoToExpidexa,
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Go to Expidexa",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Optional secondary action
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Back",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
