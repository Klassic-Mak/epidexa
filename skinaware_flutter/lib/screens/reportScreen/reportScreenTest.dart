import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinaware_flutter/providers/onboarding_data_provider.dart';
import 'package:skinaware_flutter/providers/userProvider.dart';

class ReportSkinTestScreen extends ConsumerStatefulWidget {
  const ReportSkinTestScreen({super.key});

  @override
  ConsumerState<ReportSkinTestScreen> createState() => _ReportSkinTestScreenState();
}

class _ReportSkinTestScreenState extends ConsumerState<ReportSkinTestScreen> {
  static const primaryColor = Color(0xFF0284C7);

  int _selectedTab = 0;
  int _selectedWeek = 0;
  bool _isLoading = true;

  final List<String> _weeks = const ["Week 1", "Week 2", "Week 3", "Week 4"];

  // Example data sets per tab (0..100)
  final Map<int, List<double>> _seriesByTab = {
    0: [22, 45, 38, 42, 50, 46, 76, 30],
    1: [55, 52, 48, 50, 49, 44, 40, 38],
    2: [35, 37, 40, 43, 50, 58, 70, 62],
    3: [28, 34, 46, 41, 55, 63, 58, 49],
  };

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

  /// Generate dynamic metric tabs based on user's profile
  List<_MetricTab> _buildMetricTabs(OnboardingData profileData) {
    final tabs = <_MetricTab>[];
    final concerns = profileData.skinConcerns.map((c) => c.toLowerCase()).toList();
    final skinType = profileData.skinType?.name.toLowerCase();

    // Always include hydration (important for all skin types)
    tabs.add(const _MetricTab("Hydration", Icons.opacity_outlined, "hydration"));

    // Add tabs based on skin type
    if (skinType == 'sensitive' || profileData.skinSensitivity == 'high') {
      tabs.add(const _MetricTab("Sensitivity", Icons.spa_outlined, "sensitivity"));
    }

    if (skinType == 'oily' || concerns.contains('oiliness') || concerns.contains('acne')) {
      tabs.add(const _MetricTab("Oil Control", Icons.water_drop_outlined, "oil"));
    }

    // Add tabs based on concerns
    if (concerns.contains('aging') || concerns.contains('wrinkles') || concerns.contains('fine lines')) {
      tabs.add(const _MetricTab("Elasticity", Icons.autorenew_outlined, "elasticity"));
    }

    if (concerns.contains('acne') || concerns.contains('breakouts')) {
      tabs.add(const _MetricTab("Clarity", Icons.face_retouching_natural_outlined, "clarity"));
    }

    if (concerns.contains('dark spots') || concerns.contains('hyperpigmentation') || concerns.contains('uneven tone')) {
      tabs.add(const _MetricTab("Brightness", Icons.wb_sunny_outlined, "brightness"));
    }

    if (concerns.contains('dryness')) {
      tabs.add(const _MetricTab("Moisture", Icons.water_outlined, "moisture"));
    }

    // Default tabs if profile not complete
    if (tabs.length < 3) {
      if (!tabs.any((t) => t.key == "elasticity")) {
        tabs.add(const _MetricTab("Elasticity", Icons.autorenew_outlined, "elasticity"));
      }
      if (!tabs.any((t) => t.key == "sensitivity")) {
        tabs.add(const _MetricTab("Sensitivity", Icons.spa_outlined, "sensitivity"));
      }
    }

    return tabs.take(4).toList(); // Max 4 tabs
  }

  /// Generate personalized recommendations
  List<String> _buildRecommendations(OnboardingData profileData) {
    final recommendations = <String>[];
    final concerns = profileData.skinConcerns.map((c) => c.toLowerCase()).toList();
    final skinType = profileData.skinType?.name.toLowerCase();

    // Base recommendations
    recommendations.add("Use a gentle cleanser and avoid over-scrubbing.");
    recommendations.add("Wear sunscreen every morning to stabilize trends.");

    // Skin type specific
    if (skinType == 'oily') {
      recommendations.add("Use oil-free, non-comedogenic moisturizers.");
      recommendations.add("Consider niacinamide to help regulate oil production.");
    } else if (skinType == 'dry') {
      recommendations.add("Apply a rich, hydrating moisturizer twice daily.");
      recommendations.add("Use a hydrating serum with hyaluronic acid.");
    } else if (skinType == 'sensitive') {
      recommendations.add("Stick to fragrance-free products to minimize irritation.");
      recommendations.add("Patch test new products before full application.");
    } else if (skinType == 'combination') {
      recommendations.add("Use different products for T-zone and cheeks.");
    }

    // Concern specific
    if (concerns.contains('acne') || concerns.contains('breakouts')) {
      recommendations.add("Consider salicylic acid or benzoyl peroxide for breakouts.");
      recommendations.add("Keep pillowcases clean and change them frequently.");
    }

    if (concerns.contains('aging') || concerns.contains('wrinkles')) {
      recommendations.add("Use retinol at night to boost collagen production.");
      recommendations.add("Apply vitamin C in the morning for antioxidant protection.");
    }

    if (concerns.contains('dark spots') || concerns.contains('hyperpigmentation')) {
      recommendations.add("Use vitamin C serum daily for brightening effects.");
      recommendations.add("Never skip sunscreen - UV exposure worsens dark spots.");
    }

    // Lifestyle based
    if (profileData.waterIntake == 'low') {
      recommendations.add("Increase water intake to at least 8 glasses daily.");
    }

    if (profileData.sleepQuality == 'poor' || profileData.sleepQuality == 'fair') {
      recommendations.add("Aim for 7-9 hours of sleep for optimal skin repair.");
    }

    if (profileData.stressLevel == 'high') {
      recommendations.add("Practice stress management - high stress affects skin health.");
    }

    return recommendations.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileData = ref.watch(onboardingDataProvider);
    final user = ref.watch(userProvider);

    final tabs = _buildMetricTabs(profileData);

    // Ensure selected tab is valid
    if (_selectedTab >= tabs.length) {
      _selectedTab = 0;
    }

    final series = _seriesByTab[_selectedTab] ?? const [30, 35, 40, 50, 45, 55, 60, 50];
    final current = series.isNotEmpty ? series.last : 0.0;
    final avg = series.isEmpty ? 0.0 : (series.reduce((a, b) => a + b) / series.length);
    final trend = current - series.first;

    final insight = _buildInsight(
      tabName: tabs[_selectedTab].label,
      avg: avg,
      current: current,
      trend: trend,
      profileData: profileData,
    );

    final recommendations = _buildRecommendations(profileData);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          children: [
            const SizedBox(height: 6),

            // Header with personalization badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Skin Analysis Report",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF0F172A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (profileData.isComplete)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_outline, size: 14, color: Color(0xFF10B981)),
                        const SizedBox(width: 4),
                        Text(
                          'Personalized',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),

            // Profile Summary Card
            if (!_isLoading && profileData.isComplete)
              _ProfileSummaryCard(profileData: profileData, user: user),

            if (!_isLoading && profileData.isComplete)
              const SizedBox(height: 14),

            // Chips row (personalized metrics)
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final selected = i == _selectedTab;
                  return _MetricChip(
                    label: tabs[i].label,
                    icon: tabs[i].icon,
                    selected: selected,
                    primaryColor: primaryColor,
                    onTap: () => setState(() => _selectedTab = i),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // Chart Card
            _CardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Week of ${_selectedWeek == 0 ? "1 - 7 Jan 2026" : _selectedWeek == 1 ? "8 - 14 Jan 2026" : _selectedWeek == 2 ? "15 - 21 Jan 2026" : "22 - 28 Jan 2026"}",
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _WeekDropdown(
                        value: _weeks[_selectedWeek],
                        items: _weeks,
                        onChanged: (v) {
                          final idx = _weeks.indexOf(v);
                          if (idx >= 0) setState(() => _selectedWeek = idx);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 190,
                    child: _LineChartCard(
                      primaryColor: primaryColor,
                      series: series,
                      markerIndex: math.min(4, series.length - 1),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Quick stats
                  Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          title: "Average",
                          value: "${avg.round()}%",
                          icon: Icons.analytics_outlined,
                          primaryColor: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MiniStat(
                          title: "Current",
                          value: "${current.round()}%",
                          icon: Icons.trending_up_rounded,
                          primaryColor: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MiniStat(
                          title: "Change",
                          value: "${trend >= 0 ? "+" : ""}${trend.round()}%",
                          icon: Icons.swap_vert_rounded,
                          primaryColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Personalized Insight
            _CardShell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.lightbulb_outline_rounded, color: primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Personalized Insight",
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: const Color(0xFF0F172A),
                                fontWeight: FontWeight.w800,
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
                                  'AI',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          insight,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF475569),
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Focus Areas (based on user's concerns)
            if (profileData.skinConcerns.isNotEmpty) ...[
              _CardShell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Your Focus Areas",
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            profileData.primaryConcern ?? 'Primary',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profileData.skinConcerns.map((concern) {
                        final isPrimary = concern == profileData.primaryConcern;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isPrimary ? primaryColor.withOpacity(0.12) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isPrimary ? primaryColor.withOpacity(0.3) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isPrimary)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Icon(Icons.star, size: 14, color: primaryColor),
                                ),
                              Text(
                                concern,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isPrimary ? primaryColor : const Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Report score section
            Row(
              children: [
                Text(
                  "Report score",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF0F172A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text("View all"),
                ),
              ],
            ),
            Text(
              "Based on your ${profileData.skinType?.name.toLowerCase() ?? 'skin'} type profile",
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 10),

            _ScoreRow(
              primaryColor: primaryColor,
              title: "Overall skin health",
              subtitle: _getScoreSubtitle(profileData, "overall"),
              score: _calculateScore(profileData, "overall"),
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _ScoreRow(
              primaryColor: primaryColor,
              title: _getScoreTitle(profileData, 1),
              subtitle: _getScoreSubtitle(profileData, "metric1"),
              score: _calculateScore(profileData, "metric1"),
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _ScoreRow(
              primaryColor: primaryColor,
              title: _getScoreTitle(profileData, 2),
              subtitle: _getScoreSubtitle(profileData, "metric2"),
              score: _calculateScore(profileData, "metric2"),
              onTap: () {},
            ),

            const SizedBox(height: 14),

            // Personalized Recommendations
            _CardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Recommended for you",
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF0F172A),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      if (profileData.isComplete)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Personalized',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...recommendations.map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _Bullet(primaryColor: primaryColor, text: rec),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getScoreTitle(OnboardingData profileData, int index) {
    final concerns = profileData.skinConcerns;
    if (concerns.isEmpty) {
      return index == 1 ? "Hydration level" : "Skin barrier";
    }

    final concernTitles = {
      'acne': 'Clarity score',
      'breakouts': 'Breakout control',
      'aging': 'Anti-aging progress',
      'wrinkles': 'Elasticity score',
      'dark spots': 'Brightness level',
      'hyperpigmentation': 'Tone evenness',
      'dryness': 'Moisture level',
      'oiliness': 'Oil control',
      'sensitivity': 'Barrier strength',
    };

    for (final concern in concerns) {
      final title = concernTitles[concern.toLowerCase()];
      if (title != null) {
        if (index == 1) return title;
        index--;
      }
    }

    return index == 1 ? "Hydration level" : "Skin barrier";
  }

  String _getScoreSubtitle(OnboardingData profileData, String type) {
    final skinType = profileData.skinType?.name.toLowerCase() ?? 'normal';

    switch (type) {
      case 'overall':
        return "Based on your $skinType skin analysis";
      case 'metric1':
        if (profileData.primaryConcern != null) {
          return "Tracking ${profileData.primaryConcern!.toLowerCase()} progress";
        }
        return "Daily hydration tracking";
      case 'metric2':
        return "Skin barrier health indicators";
      default:
        return "Analysis in progress";
    }
  }

  int _calculateScore(OnboardingData profileData, String type) {
    // Simulate scores based on profile (in real app, this would come from actual analysis)
    final base = 70;
    final random = math.Random();

    if (type == 'overall') {
      return base + random.nextInt(20);
    } else if (type == 'metric1') {
      return base - 10 + random.nextInt(25);
    } else {
      return base - 5 + random.nextInt(22);
    }
  }

  String _buildInsight({
    required String tabName,
    required double avg,
    required double current,
    required double trend,
    required OnboardingData profileData,
  }) {
    final trendWord = trend >= 0 ? "improving" : "dropping";
    final severity = (current - avg).abs();

    String profileContext = "";
    if (profileData.skinType != null) {
      profileContext = "For your ${profileData.skinType!.name.toLowerCase()} skin, ";
    }

    String extra;
    if (severity < 6) {
      extra = "${profileContext}your results are close to your weekly average, which usually means your routine is stable.";
    } else if (current > avg) {
      extra = "${profileContext}you're above your weekly baseline—keep the same routine for a few more days to confirm the improvement.";
    } else {
      extra = "${profileContext}you're below your weekly baseline—consider simplifying your routine and focusing on hydration + barrier care.";
    }

    // Add concern-specific insight
    String concernInsight = "";
    if (profileData.primaryConcern != null) {
      switch (profileData.primaryConcern!.toLowerCase()) {
        case 'acne':
          concernInsight = " Given your focus on acne, monitor breakout patterns alongside these metrics.";
          break;
        case 'dryness':
          concernInsight = " With dryness as your primary concern, pay extra attention to hydration levels.";
          break;
        case 'aging':
        case 'wrinkles':
          concernInsight = " For anti-aging, elasticity trends are especially important to track.";
          break;
      }
    }

    return "$tabName is currently ${current.round()}% and looks $trendWord (${trend >= 0 ? "+" : ""}${trend.round()}% vs start of week). "
        "Weekly average is ${avg.round()}%. $extra$concernInsight";
  }
}

// ======================== Profile Summary Card ========================

class _ProfileSummaryCard extends StatelessWidget {
  final OnboardingData profileData;
  final dynamic user;

  const _ProfileSummaryCard({required this.profileData, this.user});

  @override
  Widget build(BuildContext context) {
    final skinType = profileData.skinType?.name.toLowerCase().replaceAll('_', ' ') ?? 'Not set';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0284C7).withOpacity(0.08),
            const Color(0xFF0284C7).withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.analytics_outlined, color: Color(0xFF0284C7), size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Analyzing ${_capitalize(skinType)} Skin",
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${profileData.skinConcerns.length} concern${profileData.skinConcerns.length != 1 ? 's' : ''} tracked • ${profileData.skinGoals.length} goal${profileData.skinGoals.length != 1 ? 's' : ''} set",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

// ======================== UI pieces ========================

class _MetricTab {
  final String label;
  final IconData icon;
  final String key;
  const _MetricTab(this.label, this.icon, this.key);
}

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFE8EEF6)),
      ),
      child: child,
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _MetricChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? primaryColor : const Color(0xFFF1F5F9);
    final fg = selected ? Colors.white : const Color(0xFF0F172A);
    final border = selected ? primaryColor : const Color(0xFFE2E8F0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _WeekDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                    ),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color primaryColor;

  const _MiniStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: primaryColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final Color primaryColor;
  final String title;
  final String subtitle;
  final int score;
  final VoidCallback onTap;

  const _ScoreRow({
    required this.primaryColor,
    required this.title,
    required this.subtitle,
    required this.score,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EEF6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.description_outlined, color: primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "$score%",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final Color primaryColor;
  final String text;

  const _Bullet({required this.primaryColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.check_rounded, size: 14, color: primaryColor),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

// ======================== Chart (no packages) ========================

class _LineChartCard extends StatelessWidget {
  final Color primaryColor;
  final List<double> series;
  final int markerIndex;

  const _LineChartCard({
    required this.primaryColor,
    required this.series,
    required this.markerIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(
        primaryColor: primaryColor,
        series: series,
        markerIndex: markerIndex.clamp(0, math.max(0, series.length - 1)),
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final Color primaryColor;
  final List<double> series;
  final int markerIndex;

  _LineChartPainter({
    required this.primaryColor,
    required this.series,
    required this.markerIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leftPad = 36.0;
    final rightPad = 12.0;
    final topPad = 12.0;
    final bottomPad = 28.0;

    final chartW = size.width - leftPad - rightPad;
    final chartH = size.height - topPad - bottomPad;

    final rect = Rect.fromLTWH(leftPad, topPad, chartW, chartH);

    // Background
    final bg = Paint()..color = const Color(0xFFF8FAFC);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ),
      bg,
    );

    // Grid + Y labels
    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final labelStyle = const TextStyle(
      color: Color(0xFF94A3B8),
      fontSize: 11,
      fontWeight: FontWeight.w700,
    );

    for (int i = 0; i <= 5; i++) {
      final t = i / 5.0;
      final y = rect.top + rect.height * t;
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), gridPaint);

      final value = (100 - (t * 100)).round();
      final tp = TextPainter(
        text: TextSpan(text: "$value%", style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: leftPad - 6);
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // X labels
    const months = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final xLabelStyle = const TextStyle(
      color: Color(0xFF94A3B8),
      fontSize: 11,
      fontWeight: FontWeight.w700,
    );
    for (int i = 0; i < months.length; i++) {
      final x = rect.left + (rect.width * (i / (months.length - 1)));
      final tp = TextPainter(
        text: TextSpan(text: months[i], style: xLabelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, rect.bottom + 6));
    }

    if (series.length < 2) return;

    double clamp01(double v) => v.clamp(0.0, 100.0);

    final points = <Offset>[];
    for (int i = 0; i < series.length; i++) {
      final x = rect.left + rect.width * (i / (series.length - 1));
      final y = rect.top + rect.height * (1 - (clamp01(series[i]) / 100));
      points.add(Offset(x, y));
    }

    // Fill under line
    final fillPath = Path()
      ..moveTo(points.first.dx, rect.bottom)
      ..lineTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath
      ..lineTo(points.last.dx, rect.bottom)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withOpacity(0.18),
          primaryColor.withOpacity(0.02),
        ],
      ).createShader(rect);

    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Marker
    final mi = markerIndex.clamp(0, points.length - 1);
    final m = points[mi];

    final dashPaint = Paint()
      ..color = primaryColor.withOpacity(0.55)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    _drawDashedLine(canvas, dashPaint, Offset(m.dx, rect.top), Offset(m.dx, rect.bottom), dash: 6, gap: 6);

    canvas.drawCircle(m, 7, Paint()..color = Colors.white);
    canvas.drawCircle(m, 5, Paint()..color = primaryColor);

    // Bubble label
    final bubbleText = "${series[mi].round()}%";
    final bubbleTP = TextPainter(
      text: TextSpan(
        text: bubbleText,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final bubbleW = bubbleTP.width + 18;
    final bubbleH = bubbleTP.height + 10;
    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(m.dx, rect.top + 16), width: bubbleW, height: bubbleH),
      const Radius.circular(12),
    );

    final bubblePaint = Paint()..color = primaryColor;
    canvas.drawRRect(bubbleRect, bubblePaint);

    final tip = Path();
    tip.moveTo(m.dx - 7, bubbleRect.bottom);
    tip.lineTo(m.dx + 7, bubbleRect.bottom);
    tip.lineTo(m.dx, bubbleRect.bottom + 8);
    tip.close();
    canvas.drawPath(tip, bubblePaint);

    bubbleTP.paint(
      canvas,
      Offset(bubbleRect.center.dx - bubbleTP.width / 2, bubbleRect.center.dy - bubbleTP.height / 2),
    );
  }

  void _drawDashedLine(
    Canvas canvas,
    Paint paint,
    Offset a,
    Offset b, {
    required double dash,
    required double gap,
  }) {
    final total = (b - a);
    final len = total.distance;
    final dir = total / len;

    double t = 0;
    while (t < len) {
      final start = a + dir * t;
      final end = a + dir * math.min(t + dash, len);
      canvas.drawLine(start, end, paint);
      t += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.markerIndex != markerIndex ||
        oldDelegate.series != series;
  }
}
