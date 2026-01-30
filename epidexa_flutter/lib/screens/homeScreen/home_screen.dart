import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinaware_flutter/constants.dart';
import 'package:skinaware_flutter/providers/onboarding_data_provider.dart';
import 'package:skinaware_flutter/providers/userProvider.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';
import 'package:skinaware_flutter/screens/homeScreen/components/skin_score_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    await ref.read(onboardingDataProvider.notifier).loadFromPrefs();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final profileData = ref.watch(onboardingDataProvider);
    final userName = user?.name?.split(' ').first ?? 'there';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,\n$userName",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Skin Profile Summary Card
                    if (!_isLoading && profileData.isComplete)
                      _SkinProfileCard(profileData: profileData),

                    if (!_isLoading && profileData.isComplete)
                      const SizedBox(height: 16),

                    SkinScoreWidget(),
                    const SizedBox(height: 20),

                    // Personalized Daily Tip
                    _PersonalizedTipCard(profileData: profileData),
                  ],
                ),
              ),

              TitleWithNavText(
                leftTitle: 'Activities',
                rightTitle: 'See all',
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActivityCardWidget(
                        onTap: () {
                          Navigator.pushNamed(context, scanRoute);
                        },
                        title: 'Face analysis',
                        subtitle: 'Scan your face to analyze skin health',
                        iconData: Icons.face_retouching_natural,
                        iconBgColor: Colors.orange,
                      ),
                      const SizedBox(width: 16),
                      ActivityCardWidget(
                        onTap: () {
                          Navigator.pushNamed(context, chatRoute);
                        },
                        title: 'Ask Dr. Epi',
                        subtitle: 'Get personalized skincare advice',
                        iconData: Icons.chat_bubble_outline,
                        iconBgColor: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const WeeklyStreakCard(streakDays: 4),
                    const SizedBox(height: 16),

                    // User's skin goals from profile
                    _PersonalizedGoalsCard(profileData: profileData),

                    const SizedBox(height: 16),
                    TodayRoutineChecklist(profileData: profileData),
                    const SizedBox(height: 16),

                    // Lifestyle trackers based on profile
                    _LifestyleSection(profileData: profileData),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skin Profile Summary Card
class _SkinProfileCard extends StatelessWidget {
  final OnboardingData profileData;

  const _SkinProfileCard({required this.profileData});

  @override
  Widget build(BuildContext context) {
    final skinType = profileData.skinType?.name.toLowerCase().replaceAll('_', ' ') ?? 'Not set';
    final primaryConcern = profileData.primaryConcern ?? (profileData.skinConcerns.isNotEmpty ? profileData.skinConcerns.first : 'Not set');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.person_outline, color: primaryColor),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Your Skin Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Icon(Icons.edit_outlined, color: primaryColor, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ProfileInfoChip(
                  label: 'Skin Type',
                  value: _capitalize(skinType),
                  icon: Icons.water_drop_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProfileInfoChip(
                  label: 'Focus Area',
                  value: _capitalize(primaryConcern),
                  icon: Icons.center_focus_strong_outlined,
                ),
              ),
            ],
          ),
          if (profileData.skinSensitivity != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ProfileInfoChip(
                    label: 'Sensitivity',
                    value: _capitalize(profileData.skinSensitivity!),
                    icon: Icons.spa_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProfileInfoChip(
                    label: 'Goals',
                    value: '${profileData.skinGoals.length} active',
                    icon: Icons.flag_outlined,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class _ProfileInfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileInfoChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Personalized Daily Tip based on user's skin profile
class _PersonalizedTipCard extends StatelessWidget {
  final OnboardingData profileData;

  const _PersonalizedTipCard({required this.profileData});

  String _getTip() {
    // Generate personalized tips based on skin type and concerns
    final skinType = profileData.skinType;
    final concerns = profileData.skinConcerns;
    final primaryConcern = profileData.primaryConcern;

    if (primaryConcern != null) {
      switch (primaryConcern.toLowerCase()) {
        case 'acne':
          return 'Keep your pillowcases clean and change them frequently to prevent acne breakouts.';
        case 'dryness':
          return 'Apply moisturizer on slightly damp skin to lock in hydration more effectively.';
        case 'aging':
        case 'wrinkles':
          return 'Retinoids work best at night. Always follow with a good moisturizer.';
        case 'hyperpigmentation':
        case 'dark spots':
          return 'Vitamin C serum in the morning helps brighten skin and fade dark spots over time.';
        case 'sensitivity':
          return 'Patch test new products on your inner arm before applying to your face.';
        case 'oiliness':
          return 'Even oily skin needs hydration! Use a lightweight, oil-free moisturizer.';
      }
    }

    if (skinType != null) {
      switch (skinType.name.toLowerCase()) {
        case 'oily':
          return 'Skipping moisturizer can make your skin produce even more oil. Choose a gel-based moisturizer instead.';
        case 'dry':
          return 'Apply a hydrating serum before your moisturizer to boost your skin\'s hydration levels.';
        case 'combination':
          return 'Use different products for different zones - lighter formulas for T-zone, richer ones for cheeks.';
        case 'sensitive':
          return 'Less is more! Stick to a simple routine with fragrance-free products.';
        case 'normal':
          return 'Maintain your healthy skin by wearing SPF 30+ daily, even on cloudy days.';
      }
    }

    return 'Consistency is key! Stick to your skincare routine for at least 4-6 weeks to see results.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: greyColor, width: 0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFF5B23C),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Daily Tip',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    if (profileData.isComplete) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'For you',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _getTip(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF374151),
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

/// Personalized Goals Card showing user's actual skincare goals
class _PersonalizedGoalsCard extends ConsumerWidget {
  final OnboardingData profileData;

  const _PersonalizedGoalsCard({required this.profileData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = profileData.skinGoals.isNotEmpty
        ? profileData.skinGoals
        : ['Hydration', 'Clear skin', 'Even tone'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your Skincare Goals',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              if (profileData.skinGoals.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 14, color: const Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(
                        'Personalized',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: goals.map((goal) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: primaryColor.withOpacity(0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flag_outlined, size: 14, color: primaryColor),
                    const SizedBox(width: 6),
                    Text(
                      goal,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (profileData.primaryConcern != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, size: 18, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Primary focus: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    profileData.primaryConcern!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.amber.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Lifestyle Section with personalized recommendations
class _LifestyleSection extends StatefulWidget {
  final OnboardingData profileData;

  const _LifestyleSection({required this.profileData});

  @override
  State<_LifestyleSection> createState() => _LifestyleSectionState();
}

class _LifestyleSectionState extends State<_LifestyleSection> {
  int waterCups = 0;
  double sleepHours = 0;

  String _getWaterGoal() {
    switch (widget.profileData.waterIntake?.toLowerCase()) {
      case 'low':
        return 'Try to drink more water! Aim for 8 cups today.';
      case 'moderate':
        return 'Good hydration! Keep it up with 8+ cups daily.';
      case 'high':
        return 'Great job staying hydrated!';
      default:
        return 'Track your water intake for healthier skin.';
    }
  }

  String _getSleepAdvice() {
    switch (widget.profileData.sleepQuality?.toLowerCase()) {
      case 'poor':
        return 'Better sleep = better skin. Aim for 7-9 hours.';
      case 'fair':
        return 'Try to improve your sleep quality for skin repair.';
      case 'good':
      case 'excellent':
        return 'Great sleep helps your skin regenerate!';
      default:
        return 'Track your sleep for skin recovery insights.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Lifestyle Tracking',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF111827),
              ),
            ),
            const Spacer(),
            if (widget.profileData.waterIntake != null || widget.profileData.sleepQuality != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Based on your profile',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MiniTrackerCard(
                title: 'Water',
                subtitle: _getWaterGoal(),
                icon: Icons.local_drink_outlined,
                valueText: '$waterCups cups',
                onMinus: () => setState(() => waterCups = (waterCups - 1).clamp(0, 20)),
                onPlus: () => setState(() => waterCups = (waterCups + 1).clamp(0, 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MiniTrackerCard(
                title: 'Sleep',
                subtitle: _getSleepAdvice(),
                icon: Icons.bedtime_outlined,
                valueText: '${sleepHours.toStringAsFixed(1)} hrs',
                onMinus: () => setState(() => sleepHours = (sleepHours - 0.5).clamp(0, 24)),
                onPlus: () => setState(() => sleepHours = (sleepHours + 0.5).clamp(0, 24)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// Existing widgets (with minor updates)
// ============================================================================

class ActivityCardWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String subtitle;
  final IconData iconData;
  final Color iconBgColor;

  const ActivityCardWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 95,
        width: 290,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconData, color: iconBgColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

class TitleWithNavText extends StatelessWidget {
  final String leftTitle;
  final String rightTitle;
  final VoidCallback onTap;

  const TitleWithNavText({
    super.key,
    required this.leftTitle,
    required this.rightTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: defaultPadding,
        top: 6,
        right: defaultPadding,
        bottom: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftTitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              rightTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: primaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyStreakCard extends StatelessWidget {
  const WeeklyStreakCard({super.key, required this.streakDays});

  final int streakDays;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF111827),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.local_fire_department, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Routine streak',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$streakDays days in a row — keep it going!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withOpacity(0.12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            child: const Text('View', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class TodayRoutineChecklist extends StatefulWidget {
  final OnboardingData profileData;

  const TodayRoutineChecklist({super.key, required this.profileData});

  @override
  State<TodayRoutineChecklist> createState() => _TodayRoutineChecklistState();
}

class _TodayRoutineChecklistState extends State<TodayRoutineChecklist> {
  late List<_RoutineItem> items;

  @override
  void initState() {
    super.initState();
    items = _buildRoutineItems();
  }

  List<_RoutineItem> _buildRoutineItems() {
    final baseItems = [
      _RoutineItem(title: 'Cleanser', subtitle: 'AM / PM', done: false, icon: Icons.water_drop_outlined),
      _RoutineItem(title: 'Moisturizer', subtitle: 'Lock in hydration', done: false, icon: Icons.spa_outlined),
      _RoutineItem(title: 'Sunscreen', subtitle: 'SPF 30+', done: false, icon: Icons.wb_sunny_outlined),
    ];

    // Add personalized items based on concerns
    final concerns = widget.profileData.skinConcerns.map((c) => c.toLowerCase()).toList();
    final skinType = widget.profileData.skinType?.name.toLowerCase();

    if (concerns.contains('acne') || concerns.contains('breakouts')) {
      baseItems.add(_RoutineItem(
        title: 'Spot treatment',
        subtitle: 'Target breakouts',
        done: false,
        icon: Icons.healing_outlined,
      ));
    }

    if (concerns.contains('aging') || concerns.contains('wrinkles')) {
      baseItems.add(_RoutineItem(
        title: 'Anti-aging serum',
        subtitle: 'PM only',
        done: false,
        icon: Icons.auto_fix_high_outlined,
      ));
    }

    if (skinType == 'dry' || concerns.contains('dryness')) {
      baseItems.add(_RoutineItem(
        title: 'Hydrating serum',
        subtitle: 'Boost moisture',
        done: false,
        icon: Icons.opacity_outlined,
      ));
    }

    if (concerns.contains('dark spots') || concerns.contains('hyperpigmentation')) {
      baseItems.add(_RoutineItem(
        title: 'Vitamin C',
        subtitle: 'AM brightening',
        done: false,
        icon: Icons.wb_twilight_outlined,
      ));
    }

    return baseItems;
  }

  int get doneCount => items.where((e) => e.done).length;

  @override
  Widget build(BuildContext context) {
    final progress = items.isEmpty ? 0.0 : doneCount / items.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Today's routine",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              if (widget.profileData.isComplete)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Personalized',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              Text(
                '$doneCount/${items.length}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 14),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final it = entry.value;

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() => items[index] = it.copyWith(done: !it.done));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: it.done ? primaryColor.withOpacity(0.06) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: it.done ? primaryColor.withOpacity(0.25) : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: (it.done ? primaryColor : Colors.grey.shade200).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        it.icon,
                        color: it.done ? primaryColor : Colors.grey.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            it.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13.5,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            it.subtitle,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      it.done ? Icons.check_circle : Icons.circle_outlined,
                      color: it.done ? primaryColor : Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MiniTrackerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String valueText;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _MiniTrackerCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.valueText,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primaryColor, size: 20),
              ),
              const Spacer(),
              _RoundIconButton(icon: Icons.remove, onTap: onMinus),
              const SizedBox(width: 8),
              _RoundIconButton(icon: Icons.add, onTap: onPlus),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            valueText,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF111827)),
      ),
    );
  }
}

class _RoutineItem {
  final String title;
  final String subtitle;
  final bool done;
  final IconData icon;

  const _RoutineItem({
    required this.title,
    required this.subtitle,
    required this.done,
    required this.icon,
  });

  _RoutineItem copyWith({bool? done}) => _RoutineItem(
    title: title,
    subtitle: subtitle,
    done: done ?? this.done,
    icon: icon,
  );
}
