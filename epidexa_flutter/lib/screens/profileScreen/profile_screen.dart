import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skinaware_client/skinaware_client.dart';
import 'package:skinaware_flutter/constants.dart';
import 'package:skinaware_flutter/general_components/divider_list_tile.dart';
import 'package:skinaware_flutter/general_components/pop.dart';
import 'package:skinaware_flutter/general_components/shimmers/shimmer_widget.dart';
import 'package:skinaware_flutter/providers/userProvider.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  bool isShowHi = true;
  bool isShowSeller = false;

  ProfileScreen({
    super.key,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationEnabled = false;
  bool _isDoctor = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
    _checkUserRole();
  }

  void _checkUserRole() {
    final user = ref.read(userProvider);
    if (user != null) {
      setState(() {
        _isDoctor = user.role == Role.DOCTOR;
      });
    }
  }

  Future<void> _toggleDoctorRole(bool value) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    setState(() {
      _isDoctor = value;
    });

    final newRole = value ? Role.DOCTOR : Role.USER;
    ref.read(userProvider.notifier).updateProfile(role: newRole);

    if (mounted) {
      showTopToast(
        context,
        value ? 'Switched to Doctor mode' : 'Switched to User mode',
        isSuccess: true,
      );
    }
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _notificationEnabled = status.isGranted;
    });
  }

  Future<void> _handleNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      _showNotificationDialog(
        title: 'Notifications Enabled',
        message: 'You will receive reminders, tips, and updates.',
      );
      return;
    }

    if (status.isDenied) {
      final result = await Permission.notification.request();
      setState(() {
        _notificationEnabled = result.isGranted;
      });

      if (result.isGranted) {
        if (mounted) {
          showTopToast(
            context,
            'Notifications enabled successfully',
            isSuccess: true,
          );
        }
      } else if (result.isPermanentlyDenied) {
        _showPermissionDeniedDialog();
      }
      return;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
    }
  }

  void _showNotificationDialog({
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Notification permission is disabled. Please enable it in Settings to receive updates and reminders.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(c).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogOut(BuildContext context) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(c).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(c).pop(true),
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    ref.read(userProvider.notifier).logout();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        onBoarding1Route,
        (r) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final String name = user?.name ?? 'User';
    final String email = user?.email ?? '';
    final String imagesrc =
        user?.profilePhoto ??
        'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png';
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200, width: 0.5),
                borderRadius: const BorderRadius.all(
                  Radius.circular(defaultBorderRadious),
                ),
              ),
              child: Column(
                children: [
                  ProfileCard(
                    isShowHi: widget.isShowHi,
                    name: name,
                    email: email,
                    imageSrc: imagesrc,
                    proLableText: "USer",
                    //
                    isPro: widget.isShowSeller,
                    press: () {},
                  ),
                  SizedBox(height: defaultPadding),
                  Divider(
                    height: 1,
                    indent: 12,
                    endIndent: 12,
                    color: blackColor10,
                  ),
                  SizedBox(height: defaultPadding),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Checks",
                              style: TextStyle(
                                fontSize: 16,
                                color: blackColor60,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "34",
                              style: TextStyle(
                                fontSize: 16,
                                color: blackColor80,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Consultations",
                              style: TextStyle(
                                fontSize: 16,
                                color: blackColor60,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "12",
                              style: TextStyle(
                                fontSize: 16,
                                color: blackColor80,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Reviews",
                              style: TextStyle(
                                fontSize: 16,
                                color: blackColor60,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "8",
                              style: TextStyle(
                                fontSize: 16,
                                color: blackColor80,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: defaultPadding),
                ],
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Text(
              "Skin Profile",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200, width: 0.5),
                borderRadius: const BorderRadius.all(
                  Radius.circular(defaultBorderRadious),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                  vertical: 8,
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _isDoctor
                        ? primaryColor.withOpacity(0.12)
                        : Colors.grey.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.medical_services_outlined,
                    color: _isDoctor ? primaryColor : Colors.grey.shade600,
                    size: 22,
                  ),
                ),
                title: const Text(
                  "Doctor Mode",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _isDoctor
                        ? "You can provide consultations"
                        : "Switch to access doctor features",
                    style: TextStyle(
                      fontSize: 12,
                      color: blackColor60,
                      height: 1.2,
                    ),
                  ),
                ),
                trailing: Switch(
                  value: _isDoctor,
                  onChanged: _toggleDoctorRole,
                  activeColor: primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Text(
              "Personalization",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          DividerListTileWithTrilingText(
            svgSrc: "assets/icons/Notification.svg",
            title: "Notification",
            trilingText: _notificationEnabled ? "On" : "Off",
            press: _handleNotificationPermission,
          ),
          ProfileMenuListTile(
            text: "Preferences",
            svgSrc: "assets/icons/Preferences.svg",
            press: () {},
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Text(
              "Legal Terms",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),

          ProfileMenuListTile(
            text: "Terms & Policies",
            svgSrc: "assets/icons/paper.svg",
            press: () {},
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: Text(
              "Help & Support",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: "Get Help",
            svgSrc: "assets/icons/Help.svg",
            press: () {},
          ),
          ProfileMenuListTile(
            text: "FAQs",
            svgSrc: "assets/icons/FAQ.svg",
            press: () {},
            isShowDivider: false,
          ),

          const SizedBox(height: defaultPadding),

          // Log Out
          ListTile(
            onTap: () async => await _confirmLogOut(context),
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/Logout.svg",
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                errorColor,
                BlendMode.srcIn,
              ),
            ),
            title: const Text(
              "Log Out",
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          ),
          Center(
            child: Text(
              "APP VERSION : v1.0.0",
              style: TextStyle(
                fontFamily: 'Jakarta',
                fontSize: 12,
                color: blackColor60,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
