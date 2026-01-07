import 'package:flutter/material.dart';
import 'package:skinaware_flutter/constants.dart';
import 'package:skinaware_flutter/screens/homeScreen/components/external_widgets.dart';
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
      backgroundColor: const Color(0xFFF9F5EF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Good Morning,\nSarah!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'How can I help you around the house today?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFDE8C8),
                            const Color(0xFFEFEFEF),
                          ],
                        ),
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
                                  'Try saying "What\'s for dinner tonight?" and I\'ll suggest recipes based on what you have!',
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
              SizedBox(height: 16),

              VoiceWidget(
                requestController: _requestController,
                requestFormKey: _requestFormKey,
                onCall: () {},
              ),
              const SizedBox(height: 16),
              TitleWtihNavText(
                leftTitle: "Quick Actions",
                rightTitle: "See All",
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.01,
                  children: const [
                    _ActionCard(
                      icon: Icons.restaurant,
                      iconBg: Color(0xFFFFEDD5),
                      iconColor: Color(0xFFF59E0B),
                      title: 'Cooking Help',
                      subtitle: 'Recipe ideas & steps',
                    ),
                    _ActionCard(
                      icon: Icons.cleaning_services,
                      iconBg: Color(0xFFE0E7FF),
                      iconColor: Color(0xFF3B82F6),
                      title: 'Clean House',
                      subtitle: 'Step-by-step guide',
                    ),
                    _ActionCard(
                      icon: Icons.calendar_today,
                      iconBg: Color(0xFFF3E8FF),
                      iconColor: Color(0xFF8B5CF6),
                      title: 'Daily Plan',
                      subtitle: 'Organize your day',
                    ),
                    _ActionCard(
                      icon: Icons.checklist,
                      iconBg: Color(0xFFDCFCE7),
                      iconColor: Color(0xFF22C55E),
                      title: 'Task List',
                      subtitle: 'Create & manage',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TitleWtihNavText(
                leftTitle: "Recents",
                rightTitle: "View All",
                onTap: () {},
              ),
              AssistantSuggestionsWidget(),
            ],
          ),
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
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              rightTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: darkBlueColor,
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
              //       border: Border.all(color: greyColor, width: 1),
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
