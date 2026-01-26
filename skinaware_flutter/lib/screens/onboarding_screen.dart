// onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:skinaware_flutter/constants.dart'; // <-- must contain primaryColor
import 'package:skinaware_flutter/providers/on_boading_provider.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _controller;

  // ✅ Unsplash "source" URLs (simple + reliable for demos)
  // You can later replace with your own hosted assets if you want.
  final _pages = const <_OnboardPageData>[
    _OnboardPageData(
      title: "Scan your skin in seconds",
      subtitle:
          "Capture a clear photo and let SkinAware detect visible skin changes with smart analysis.",
      imageUrl: "assets/images/girl-scan.jpeg",
      chip: "Camera scan",
      icon: Icons.camera_alt_outlined,
    ),
    // _OnboardPageData(
    //   title: "Spot concerns early",
    //   subtitle:
    //       "Track dryness, irritation, and patterns that may relate to common skin conditions.",
    //   imageUrl: "https://source.unsplash.com/tWTFjznQlBA/1200x900",
    //   chip: "Skin checks",
    //   icon: Icons.health_and_safety_outlined,
    // ),
    _OnboardPageData(
      title: "Empowered with Dr. Epi",
      subtitle:
          "Use our AI assistant, Dr. Epi, to receive faster insights and more accurate skin health guidance.",

      imageUrl: "assets/images/epi-bot.png",
      chip: "Routine tips",
      icon: Icons.spa_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setIndex(int i) {
    ref.read(onboardingIndexProvider.notifier).state = i;
  }

  Future<void> _finish() async {
    ref.read(onboardingCompletedProvider.notifier).state = true;
    if (!mounted) return;
    Navigator.pushNamed(context, loginRoute);
  }

  Future<void> _next() async {
    final idx = ref.read(onboardingIndexProvider);
    final isLast = idx >= _pages.length - 1;

    if (isLast) {
      await _finish();
      return;
    }

    await _controller.animateToPage(
      idx + 1,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _skip() async {
    await _finish();
  }

  @override
  Widget build(BuildContext context) {
    final idx = ref.watch(onboardingIndexProvider);
    final isLast = idx == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
              child: Row(
                children: [
                  const _BrandMark(),
                  const Spacer(),
                  TextButton(
                    onPressed: _skip,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                    ),
                    child: const Text("Skip"),
                  ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: _setIndex,
                itemBuilder: (context, i) => _OnboardPage(data: _pages[i]),
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              child: Column(
                children: [
                  _Dots(count: _pages.length, index: idx),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _PrimaryButton(
                          onTap: _next,
                          label: isLast ? "Get started" : "Next",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tip: Use good lighting for better detection.",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPageData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String chip;
  final IconData icon;

  const _OnboardPageData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.chip,
    required this.icon,
  });
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({required this.data});
  final _OnboardPageData data;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 10),
      child: Column(
        children: [
          // Upper image section (modern)
          ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: AspectRatio(
              aspectRatio: 16 / 15.5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    data.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, _) => Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),

                  // Soft gradient overlay for readability
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.40),
                        ],
                      ),
                    ),
                  ),

                  // Top-left chip
                  Positioned(
                    left: 14,
                    top: 14,
                    child: _ChipPill(
                      icon: data.icon,
                      label: data.chip,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Content card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black.withOpacity(0.06)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(0.06),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: t.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data.subtitle,
                  style: t.bodyMedium?.copyWith(
                    color: Colors.black54,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColor.withOpacity(0.22)),
          ),
          child: Icon(Icons.spa_rounded, color: primaryColor, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          "Epidexa",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ChipPill extends StatelessWidget {
  const _ChipPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? primaryColor : Colors.black26,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.onTap, required this.label});
  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.onTap, required this.label});
  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          side: BorderSide(color: Colors.black.withOpacity(0.10)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
