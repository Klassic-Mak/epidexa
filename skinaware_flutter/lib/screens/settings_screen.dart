import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ✅ Match your theme
  static const Color primaryColor = Color(0xFF0284C7);
  static const Color pageBg = Color(0xFFF7F8FC);

  String selectedLanguage = 'English';
  String selectedSkinType = 'Combination Skin';

  final List<String> languages = const [
    'English',
    'Tiếng Việt',
    'Español',
    'Français',
  ];

  final List<String> skinTypes = const [
    'Normal Skin',
    'Dry Skin',
    'Oily Skin',
    'Combination Skin',
    'Sensitive Skin',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 22),
        children: [
          _ProfileHeader(
            primaryColor: primaryColor,
            name: "Sarah Johnson",
            meta: "Member since Jan 2024",
            onEdit: () {},
          ),
          const SizedBox(height: 12),

          _SectionCard(
            title: "Skin Profile",
            icon: Icons.water_drop_outlined,
            primaryColor: primaryColor,
            child: Column(
              children: [
                _FieldLabel("Skin type"),
                const SizedBox(height: 8),
                _ModernDropdown(
                  value: selectedSkinType,
                  items: skinTypes,
                  primaryColor: primaryColor,
                  onChanged: (v) => setState(() => selectedSkinType = v),
                ),
                const SizedBox(height: 12),
                _InfoPill(
                  primaryColor: primaryColor,
                  text:
                      "Combination skin: oilier T-zone with normal/dry cheeks. Keep cleansing gentle and hydrate consistently.",
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _SectionCard(
            title: "Medical Information",
            icon: Icons.medical_information_outlined,
            primaryColor: primaryColor,
            child: Column(
              children: [
                _SettingTile(
                  primaryColor: primaryColor,
                  icon: Icons.check_circle_outline,
                  title: "Allergies",
                  subtitle: "None reported",
                  onTap: () {},
                ),
                _DividerSoft(),
                _SettingTile(
                  primaryColor: primaryColor,
                  icon: Icons.medication_outlined,
                  title: "Current medications",
                  subtitle: "No medications",
                  onTap: () {},
                ),
                _DividerSoft(),
                _SettingTile(
                  primaryColor: primaryColor,
                  icon: Icons.wb_sunny_outlined,
                  title: "Sun sensitivity",
                  subtitle: "Moderate",
                  onTap: () {},
                ),
                _DividerSoft(),
                _SettingTile(
                  primaryColor: primaryColor,
                  icon: Icons.healing_outlined,
                  title: "Previous conditions",
                  subtitle: "Mild acne (resolved)",
                  onTap: () {},
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text("Update Medical Information"),
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _SectionCard(
            title: "Preferences",
            icon: Icons.tune_rounded,
            primaryColor: primaryColor,
            child: Column(
              children: [
                _FieldLabel("App language"),
                const SizedBox(height: 8),
                _ModernDropdown(
                  value: selectedLanguage,
                  items: languages,
                  primaryColor: primaryColor,
                  onChanged: (v) => setState(() => selectedLanguage = v),
                ),
                const SizedBox(height: 14),
                _SettingToggle(
                  primaryColor: primaryColor,
                  icon: Icons.notifications_outlined,
                  title: "Notifications",
                  subtitle: "Reminders, tips, and weekly reports",
                  value: true,
                  onChanged: (v) {},
                ),
                _DividerSoft(),
                _SettingToggle(
                  primaryColor: primaryColor,
                  icon: Icons.dark_mode_outlined,
                  title: "Dark mode",
                  subtitle: "Coming soon",
                  value: false,
                  onChanged: (v) {},
                  enabled: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _SectionCard(
            title: "Account",
            icon: Icons.person_outline,
            primaryColor: primaryColor,
            child: Column(
              children: [
                _SettingTile(
                  primaryColor: primaryColor,
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy & Security",
                  subtitle: "Password, devices, and permissions",
                  onTap: () {},
                ),
                _DividerSoft(),
                _SettingTile(
                  primaryColor: primaryColor,
                  icon: Icons.help_outline_rounded,
                  title: "Help & Support",
                  subtitle: "FAQs and contact options",
                  onTap: () {},
                ),
                _DividerSoft(),
                _SettingTile(
                  primaryColor: primaryColor,
                  icon: Icons.info_outline_rounded,
                  title: "About",
                  subtitle: "App version & legal",
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _DividerSoft(),
                _DangerTile(
                  title: "Sign out",
                  icon: Icons.logout_rounded,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Color primaryColor;
  final String name;
  final String meta;
  final VoidCallback onEdit;

  const _ProfileHeader({
    required this.primaryColor,
    required this.name,
    required this.meta,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: primaryColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meta,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined, color: primaryColor),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color primaryColor;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.primaryColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
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
        border: Border.all(color: const Color(0xFFE8EEF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontWeight: FontWeight.w800,
          fontSize: 12.5,
        ),
      ),
    );
  }
}

class _ModernDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Color primaryColor;
  final ValueChanged<String> onChanged;

  const _ModernDropdown({
    required this.value,
    required this.items,
    required this.primaryColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(14),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final Color primaryColor;
  final String text;

  const _InfoPill({required this.primaryColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryColor.withOpacity(0.20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF334155),
                fontWeight: FontWeight.w600,
                height: 1.2,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final Color primaryColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingTile({
    required this.primaryColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: primaryColor, size: 22),
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
                      fontSize: 13.5,
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
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  final Color primaryColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _SettingToggle({
    required this.primaryColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = enabled
        ? const Color(0xFF0F172A)
        : const Color(0xFF94A3B8);
    final subColor = enabled
        ? const Color(0xFF64748B)
        : const Color(0xFFCBD5E1);

    return Opacity(
      opacity: enabled ? 1 : 0.75,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: primaryColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _DangerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DangerTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFEF4444),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.w900,
                  fontSize: 13.5,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFEF4444)),
          ],
        ),
      ),
    );
  }
}

class _DividerSoft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFE8EEF6),
      ),
    );
  }
}
