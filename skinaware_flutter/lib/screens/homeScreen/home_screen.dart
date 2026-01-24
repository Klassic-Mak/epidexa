import 'package:flutter/material.dart';
import 'package:skinaware_flutter/constants.dart';
import 'package:skinaware_flutter/screens/homeScreen/components/external_widgets.dart';
import 'package:skinaware_flutter/screens/homeScreen/components/skin_score_widget.dart';
import 'package:skinaware_flutter/screens/homeScreen/components/voice_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _requestController = TextEditingController();
  GlobalKey<FormState> _requestFormKey = GlobalKey<FormState>();
  bool isListening = false;

  @override
  Widget build(BuildContext context) {
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
                    const Text(
                      "Let's take care of \nyour skin",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SkinScoreWidget(),
                    const SizedBox(height: 20),

                    Container(
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
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5B23C),
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
                              children: const [
                                Text(
                                  'Daily Tip',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Skipping moisturizer can make your skin produce even more oil. Choose a moisturizer instead.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              TitleWtihNavText(
                leftTitle: 'Activities',
                rightTitle: 'See all',
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActivityCardWidget(
                        onTap: () {},
                        title: 'Face analysis',
                        subtitle:
                            'Take your photo of your face to analyze face features',
                        iconData: Icons.face_retouching_natural,
                        iconBgColor: Colors.orange,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      ActivityCardWidget(
                        onTap: () {},
                        title: 'Lifestyle & Habits',
                        subtitle:
                            'Answer a few questions about your lifestyle & habits',
                        iconData: Icons.self_improvement,
                        iconBgColor: Colors.blue,
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
                    WeeklyStreakCard(streakDays: 4),
                    const SizedBox(height: 16),
                    SkinGoalChips(
                      onChanged: (goal) {},
                    ),
                    const SizedBox(height: 16),
                    TodayRoutineChecklist(),
                    const SizedBox(height: 16),
                    LifestyleQuickTrackers(),
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
      onTap: () {
        onTap?.call();
      },
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
              child: Icon(
                iconData,
                color: iconBgColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
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

class TitleWtihNavText extends StatelessWidget {
  final String leftTitle;
  final String rightTitle;
  final VoidCallback onTap;
  const TitleWtihNavText({
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

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _ActionCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: greyColor, width: 0.5),
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
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class SkinGoalChips extends StatefulWidget {
  const SkinGoalChips({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  State<SkinGoalChips> createState() => _SkinGoalChipsState();
}

class _SkinGoalChipsState extends State<SkinGoalChips> {
  final goals = const [
    "Hydration",
    "Acne",
    "Glow",
    "Even tone",
    "Sensitive care",
  ];
  String selected = "Hydration";

  @override
  Widget build(BuildContext context) {
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
          const Text(
            "Your skin goal",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: goals.map((g) {
              final isSelected = g == selected;
              return InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  setState(() => selected = g);
                  widget.onChanged?.call(g);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withOpacity(0.12)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isSelected
                          ? primaryColor.withOpacity(0.35)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Text(
                    g,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? primaryColor
                          : const Color(0xFF374151),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class TodayRoutineChecklist extends StatefulWidget {
  const TodayRoutineChecklist({super.key});

  @override
  State<TodayRoutineChecklist> createState() => _TodayRoutineChecklistState();
}

class _TodayRoutineChecklistState extends State<TodayRoutineChecklist> {
  final items = [
    _RoutineItem(
      title: "Cleanser",
      subtitle: "AM / PM",
      done: false,
      icon: Icons.water_drop_outlined,
    ),
    _RoutineItem(
      title: "Moisturizer",
      subtitle: "Lock in hydration",
      done: false,
      icon: Icons.spa_outlined,
    ),
    _RoutineItem(
      title: "Sunscreen",
      subtitle: "SPF 30+",
      done: false,
      icon: Icons.wb_sunny_outlined,
    ),
    _RoutineItem(
      title: "Lip care",
      subtitle: "Prevent dryness",
      done: false,
      icon: Icons.favorite_border,
    ),
  ];

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
                  "Today’s routine",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              Text(
                "$doneCount/${items.length}",
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
                  color: it.done
                      ? primaryColor.withOpacity(0.06)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: it.done
                        ? primaryColor.withOpacity(0.25)
                        : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: (it.done ? primaryColor : Colors.grey.shade200)
                            .withOpacity(0.15),
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
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
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

class LifestyleQuickTrackers extends StatefulWidget {
  const LifestyleQuickTrackers({super.key});

  @override
  State<LifestyleQuickTrackers> createState() => _LifestyleQuickTrackersState();
}

class _LifestyleQuickTrackersState extends State<LifestyleQuickTrackers> {
  int waterCups = 0; // 0..10
  double sleepHours = 0; // 0..12

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniTrackerCard(
            title: "Water",
            subtitle: "Hydration helps skin",
            icon: Icons.local_drink_outlined,
            valueText: "$waterCups cups",
            onMinus: () =>
                setState(() => waterCups = (waterCups - 1).clamp(0, 20)),
            onPlus: () =>
                setState(() => waterCups = (waterCups + 1).clamp(0, 20)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniTrackerCard(
            title: "Sleep",
            subtitle: "Recovery time",
            icon: Icons.bedtime_outlined,
            valueText: "${sleepHours.toStringAsFixed(1)} hrs",
            onMinus: () =>
                setState(() => sleepHours = (sleepHours - 0.5).clamp(0, 24)),
            onPlus: () =>
                setState(() => sleepHours = (sleepHours + 0.5).clamp(0, 24)),
          ),
        ),
      ],
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
                  "Routine streak",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$streakDays days in a row — keep it going!",
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            child: const Text(
              "View",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
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
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.grey.shade600,
            ),
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
