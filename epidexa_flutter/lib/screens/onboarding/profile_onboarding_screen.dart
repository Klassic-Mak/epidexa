import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinaware_client/skinaware_client.dart';
import 'package:skinaware_flutter/constants.dart';
import 'package:skinaware_flutter/providers/onboarding_data_provider.dart';
import 'package:skinaware_flutter/providers/userProvider.dart';
import 'package:skinaware_flutter/providers/serverpod_provider.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';

class ProfileOnboardingScreen extends ConsumerStatefulWidget {
  const ProfileOnboardingScreen({super.key});

  @override
  ConsumerState<ProfileOnboardingScreen> createState() => _ProfileOnboardingScreenState();
}

class _ProfileOnboardingScreenState extends ConsumerState<ProfileOnboardingScreen> {
  late final PageController _controller;
  int _currentPage = 0;
  bool _isSaving = false;

  final List<_OnboardingStep> _steps = [
    _OnboardingStep(
      title: 'Let\'s personalize your experience',
      subtitle: 'Answer a few questions so Dr. Epi can give you tailored recommendations.',
      type: _StepType.intro,
    ),
    _OnboardingStep(
      title: 'What\'s your skin type?',
      subtitle: 'This helps us give you tailored recommendations.',
      type: _StepType.skinType,
    ),
    _OnboardingStep(
      title: 'How sensitive is your skin?',
      subtitle: 'Knowing your sensitivity helps us recommend gentler products when needed.',
      type: _StepType.sensitivity,
    ),
    _OnboardingStep(
      title: 'What are your skin concerns?',
      subtitle: 'Select all that apply. We\'ll focus on what matters most to you.',
      type: _StepType.concerns,
    ),
    _OnboardingStep(
      title: 'Any allergies or conditions?',
      subtitle: 'This ensures our recommendations are safe for you.',
      type: _StepType.medical,
    ),
    _OnboardingStep(
      title: 'Tell us about your lifestyle',
      subtitle: 'These factors affect your skin health.',
      type: _StepType.lifestyle,
    ),
    _OnboardingStep(
      title: 'What are your skincare goals?',
      subtitle: 'What do you want to achieve with your skincare routine?',
      type: _StepType.goals,
    ),
    _OnboardingStep(
      title: 'You\'re all set!',
      subtitle: 'Dr. Epi is ready to provide personalized skin health guidance.',
      type: _StepType.complete,
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

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _finish() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      // Get current user
      final user = ref.read(userProvider);
      if (user?.id == null) {
        // No user logged in, just save locally and go to main
        await ref.read(onboardingDataProvider.notifier).saveToPrefs();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, mainPageRoute);
        return;
      }

      // Get onboarding data
      final data = ref.read(onboardingDataProvider);

      // Save to server
      final client = ref.read(serverpodClientProvider);
      final response = await client.profile.saveProfile(
        userId: user!.id!,
        skinType: data.skinType ?? SkinType.NORMAL,
        skinSensitivity: data.skinSensitivity,
        oiliness: data.oiliness,
        skinConcerns: data.skinConcerns.isNotEmpty ? data.skinConcerns.join(',') : null,
        primaryConcern: data.primaryConcern,
        knownAllergies: data.allergies.isNotEmpty ? data.allergies.join(',') : null,
        currentMedications: data.medications.isNotEmpty ? data.medications.join(',') : null,
        skinConditionHistory: data.skinConditionHistory.isNotEmpty ? data.skinConditionHistory.join(',') : null,
        sunExposure: data.sunExposure,
        waterIntake: data.waterIntake,
        sleepQuality: data.sleepQuality,
        stressLevel: data.stressLevel,
        skinGoals: data.skinGoals.isNotEmpty ? data.skinGoals.join(',') : null,
        preferredLanguage: data.preferredLanguage,
        productBudget: data.productBudget,
        routineComplexity: data.routineComplexity,
      );

      if (response.success) {
        // Also update user's skin type in the user record
        await client.user.updateProfile(
          userId: user.id!,
          skinType: data.skinType,
          age: data.age,
          gender: data.gender,
        );

        // Save locally as backup
        await ref.read(onboardingDataProvider.notifier).saveToPrefs();

        // Store profile in provider
        ref.read(userProfileProvider.notifier).state = response.profile;
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, mainPageRoute);
    } catch (e) {
      // If server save fails, save locally and continue
      await ref.read(onboardingDataProvider.notifier).saveToPrefs();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, mainPageRoute);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _skip() async {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, mainPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    final isFirstPage = _currentPage == 0;
    final isLastPage = _currentPage == _steps.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with progress
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
              child: Row(
                children: [
                  if (!isFirstPage)
                    IconButton(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  else
                    const _BrandMark(),
                  const Spacer(),
                  if (!isLastPage)
                    TextButton(
                      onPressed: _skip,
                      style: TextButton.styleFrom(foregroundColor: Colors.black54),
                      child: const Text('Skip'),
                    ),
                ],
              ),
            ),

            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _ProgressBar(
                current: _currentPage,
                total: _steps.length,
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _steps.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) => _buildStepContent(_steps[i]),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isLastPage ? 'Get Started' : 'Continue',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(_OnboardingStep step) {
    switch (step.type) {
      case _StepType.intro:
        return _IntroStep(title: step.title, subtitle: step.subtitle);
      case _StepType.skinType:
        return _SkinTypeStep(title: step.title, subtitle: step.subtitle);
      case _StepType.sensitivity:
        return _SensitivityStep(title: step.title, subtitle: step.subtitle);
      case _StepType.concerns:
        return _ConcernsStep(title: step.title, subtitle: step.subtitle);
      case _StepType.medical:
        return _MedicalStep(title: step.title, subtitle: step.subtitle);
      case _StepType.lifestyle:
        return _LifestyleStep(title: step.title, subtitle: step.subtitle);
      case _StepType.goals:
        return _GoalsStep(title: step.title, subtitle: step.subtitle);
      case _StepType.complete:
        return _CompleteStep(title: step.title, subtitle: step.subtitle);
    }
  }
}

// ============== Data Models ==============

class _OnboardingStep {
  final String title;
  final String subtitle;
  final _StepType type;

  const _OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.type,
  });
}

enum _StepType {
  intro,
  skinType,
  sensitivity,
  concerns,
  medical,
  lifestyle,
  goals,
  complete,
}

// ============== Reusable Widgets ==============

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
          'Epidexa',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final isActive = i <= current;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
            decoration: BoxDecoration(
              color: isActive ? primaryColor : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

class _StepHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StepHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black54,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SelectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _SelectionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.black12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: isSelected ? primaryColor : Colors.black54,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? primaryColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.black.withOpacity(0.08),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? primaryColor.withOpacity(0.15) : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? primaryColor : Colors.black54,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: isSelected ? primaryColor : Colors.black87,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? primaryColor : Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}

// ============== Step Widgets ==============

class _IntroStep extends StatelessWidget {
  final String title;
  final String subtitle;

  const _IntroStep({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.spa_rounded, size: 60, color: primaryColor),
          ),
          const SizedBox(height: 32),
          _StepHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 40),
          _FeatureRow(
            icon: Icons.camera_alt_outlined,
            title: 'AI Skin Analysis',
            description: 'Get instant insights from your skin photos',
          ),
          const SizedBox(height: 16),
          _FeatureRow(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Dr. Epi Assistant',
            description: 'Personalized guidance for your skin health',
          ),
          const SizedBox(height: 16),
          _FeatureRow(
            icon: Icons.security_outlined,
            title: 'Private & Secure',
            description: 'Your data stays safe and confidential',
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkinTypeStep extends ConsumerWidget {
  final String title;
  final String subtitle;

  const _SkinTypeStep({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingDataProvider);
    final notifier = ref.read(onboardingDataProvider.notifier);

    final skinTypes = [
      (SkinType.NORMAL, 'Normal', 'Balanced, not too oily or dry', Icons.check_circle_outline),
      (SkinType.OILY, 'Oily', 'Shiny, prone to breakouts', Icons.water_drop_outlined),
      (SkinType.DRY, 'Dry', 'Tight, flaky, or rough texture', Icons.wb_sunny_outlined),
      (SkinType.COMBINATION, 'Combination', 'Oily T-zone, dry cheeks', Icons.compare_arrows),
      (SkinType.SENSITIVE, 'Sensitive', 'Easily irritated or reactive', Icons.warning_amber_outlined),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _StepHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 24),
          ...skinTypes.map((type) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionCard(
              title: type.$2,
              description: type.$3,
              icon: type.$4,
              isSelected: data.skinType == type.$1,
              onTap: () => notifier.setSkinType(type.$1),
            ),
          )),
        ],
      ),
    );
  }
}

class _SensitivityStep extends ConsumerWidget {
  final String title;
  final String subtitle;

  const _SensitivityStep({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingDataProvider);
    final notifier = ref.read(onboardingDataProvider.notifier);

    final sensitivities = [
      ('low', 'Low', 'Rarely reacts to products', Icons.sentiment_very_satisfied),
      ('medium', 'Medium', 'Occasionally sensitive', Icons.sentiment_satisfied),
      ('high', 'High', 'Frequently irritated', Icons.sentiment_dissatisfied),
    ];

    final oilinessOptions = [
      ('none', 'Not Oily', 'Rarely gets shiny'),
      ('t-zone', 'T-Zone Only', 'Oily forehead, nose, chin'),
      ('all-over', 'All Over', 'Gets shiny everywhere'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 24),
          const Text(
            'Sensitivity Level',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 12),
          ...sensitivities.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OptionCard(
              title: s.$2,
              description: s.$3,
              icon: s.$4,
              isSelected: data.skinSensitivity == s.$1,
              onTap: () => notifier.setSkinSensitivity(s.$1),
            ),
          )),
          const SizedBox(height: 20),
          const Text(
            'Oiliness',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: oilinessOptions.map((o) => _SelectionChip(
              label: o.$2,
              isSelected: data.oiliness == o.$1,
              onTap: () => notifier.setOiliness(o.$1),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _ConcernsStep extends ConsumerWidget {
  final String title;
  final String subtitle;

  const _ConcernsStep({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingDataProvider);
    final notifier = ref.read(onboardingDataProvider.notifier);

    final concerns = [
      ('acne', 'Acne & Breakouts', Icons.bubble_chart),
      ('aging', 'Fine Lines & Wrinkles', Icons.elderly),
      ('dark_spots', 'Dark Spots & Pigmentation', Icons.contrast),
      ('dryness', 'Dryness & Dehydration', Icons.water_damage_outlined),
      ('redness', 'Redness & Rosacea', Icons.thermostat),
      ('pores', 'Large Pores', Icons.blur_circular),
      ('dullness', 'Dullness & Uneven Tone', Icons.brightness_low),
      ('dark_circles', 'Dark Circles', Icons.remove_red_eye_outlined),
      ('scarring', 'Scarring', Icons.healing),
      ('sun_damage', 'Sun Damage', Icons.wb_sunny),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: concerns.map((c) {
              final isSelected = data.skinConcerns.contains(c.$1);
              return _SelectionChip(
                label: c.$2,
                icon: c.$3,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    notifier.removeSkinConcern(c.$1);
                  } else {
                    notifier.addSkinConcern(c.$1);
                  }
                },
              );
            }).toList(),
          ),
          if (data.skinConcerns.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Which is your primary concern?',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: data.skinConcerns.map((c) {
                final concern = concerns.firstWhere((x) => x.$1 == c, orElse: () => (c, c, Icons.help));
                return _SelectionChip(
                  label: concern.$2,
                  isSelected: data.primaryConcern == c,
                  onTap: () => notifier.setPrimaryConcern(c),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _MedicalStep extends ConsumerStatefulWidget {
  final String title;
  final String subtitle;

  const _MedicalStep({required this.title, required this.subtitle});

  @override
  ConsumerState<_MedicalStep> createState() => _MedicalStepState();
}

class _MedicalStepState extends ConsumerState<_MedicalStep> {
  final _allergyController = TextEditingController();
  final _medicationController = TextEditingController();

  @override
  void dispose() {
    _allergyController.dispose();
    _medicationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingDataProvider);
    final notifier = ref.read(onboardingDataProvider.notifier);

    final commonAllergies = [
      'Fragrance', 'Retinol', 'Vitamin C', 'Salicylic Acid',
      'Benzoyl Peroxide', 'Sulfates', 'Parabens', 'None',
    ];

    final conditions = [
      ('eczema', 'Eczema'),
      ('psoriasis', 'Psoriasis'),
      ('rosacea', 'Rosacea'),
      ('dermatitis', 'Dermatitis'),
      ('vitiligo', 'Vitiligo'),
      ('none', 'None'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(title: widget.title, subtitle: widget.subtitle),
          const SizedBox(height: 24),

          // Allergies
          const Text(
            'Known Allergies (optional)',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select any ingredients you\'re allergic to',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: commonAllergies.map((a) {
              final isSelected = data.allergies.contains(a.toLowerCase());
              return _SelectionChip(
                label: a,
                isSelected: isSelected,
                onTap: () {
                  if (a == 'None') {
                    notifier.setAllergies([]);
                  } else if (isSelected) {
                    notifier.removeAllergy(a.toLowerCase());
                  } else {
                    notifier.addAllergy(a.toLowerCase());
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Skin condition history
          const Text(
            'Previous Skin Conditions (optional)',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: conditions.map((c) {
              final isSelected = data.skinConditionHistory.contains(c.$1);
              return _SelectionChip(
                label: c.$2,
                isSelected: isSelected,
                onTap: () {
                  if (c.$1 == 'none') {
                    notifier.setSkinConditionHistory([]);
                  } else {
                    final newList = List<String>.from(data.skinConditionHistory);
                    if (isSelected) {
                      newList.remove(c.$1);
                    } else {
                      newList.add(c.$1);
                    }
                    notifier.setSkinConditionHistory(newList);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _LifestyleStep extends ConsumerWidget {
  final String title;
  final String subtitle;

  const _LifestyleStep({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingDataProvider);
    final notifier = ref.read(onboardingDataProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 24),

          // Sun exposure
          const Text('Sun Exposure', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ('minimal', 'Minimal', 'Mostly indoors'),
              ('moderate', 'Moderate', 'Some outdoor time'),
              ('high', 'High', 'Outdoors frequently'),
            ].map((s) => _SelectionChip(
              label: '${s.$2}\n${s.$3}',
              isSelected: data.sunExposure == s.$1,
              onTap: () => notifier.setSunExposure(s.$1),
            )).toList(),
          ),

          const SizedBox(height: 20),

          // Water intake
          const Text('Daily Water Intake', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ('low', 'Less than 4 glasses'),
              ('moderate', '4-8 glasses'),
              ('high', 'More than 8 glasses'),
            ].map((w) => _SelectionChip(
              label: w.$2,
              isSelected: data.waterIntake == w.$1,
              onTap: () => notifier.setWaterIntake(w.$1),
            )).toList(),
          ),

          const SizedBox(height: 20),

          // Sleep quality
          const Text('Sleep Quality', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ('poor', 'Poor'),
              ('fair', 'Fair'),
              ('good', 'Good'),
              ('excellent', 'Excellent'),
            ].map((s) => _SelectionChip(
              label: s.$2,
              isSelected: data.sleepQuality == s.$1,
              onTap: () => notifier.setSleepQuality(s.$1),
            )).toList(),
          ),

          const SizedBox(height: 20),

          // Stress level
          const Text('Stress Level', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ('low', 'Low'),
              ('moderate', 'Moderate'),
              ('high', 'High'),
            ].map((s) => _SelectionChip(
              label: s.$2,
              isSelected: data.stressLevel == s.$1,
              onTap: () => notifier.setStressLevel(s.$1),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _GoalsStep extends ConsumerWidget {
  final String title;
  final String subtitle;

  const _GoalsStep({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingDataProvider);
    final notifier = ref.read(onboardingDataProvider.notifier);

    final goals = [
      ('clear_skin', 'Clear Skin', 'Reduce breakouts and blemishes', Icons.face_retouching_natural),
      ('anti_aging', 'Anti-Aging', 'Reduce fine lines and wrinkles', Icons.auto_awesome),
      ('hydration', 'Better Hydration', 'Plump, moisturized skin', Icons.water_drop),
      ('even_tone', 'Even Skin Tone', 'Reduce dark spots and redness', Icons.palette),
      ('glow', 'Healthy Glow', 'Radiant, luminous skin', Icons.wb_sunny_outlined),
      ('protection', 'Sun Protection', 'Prevent sun damage', Icons.shield_outlined),
      ('minimize_pores', 'Minimize Pores', 'Smaller, refined pores', Icons.blur_on),
      ('soothe', 'Calm & Soothe', 'Reduce sensitivity and irritation', Icons.spa),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 24),
          ...goals.map((g) {
            final isSelected = data.skinGoals.contains(g.$1);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OptionCard(
                title: g.$2,
                description: g.$3,
                icon: g.$4,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    notifier.removeSkinGoal(g.$1);
                  } else {
                    notifier.addSkinGoal(g.$1);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CompleteStep extends ConsumerWidget {
  final String title;
  final String subtitle;

  const _CompleteStep({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingDataProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, size: 60, color: Colors.green),
          ),
          const SizedBox(height: 32),
          _StepHeader(title: title, subtitle: subtitle),
          const SizedBox(height: 32),

          // Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Profile Summary',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 16),
                if (data.skinType != null)
                  _SummaryRow(label: 'Skin Type', value: data.skinType!.name),
                if (data.skinConcerns.isNotEmpty)
                  _SummaryRow(
                    label: 'Concerns',
                    value: data.skinConcerns.take(3).join(', ') +
                        (data.skinConcerns.length > 3 ? '...' : ''),
                  ),
                if (data.skinGoals.isNotEmpty)
                  _SummaryRow(
                    label: 'Goals',
                    value: data.skinGoals.take(3).join(', ') +
                        (data.skinGoals.length > 3 ? '...' : ''),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'You can update these preferences anytime in your profile settings.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.replaceAll('_', ' ').toLowerCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
