// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:skinaware_flutter/constants.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';
import 'package:skinaware_flutter/screens/homeScreen/home_screen.dart';
import 'package:skinaware_flutter/screens/scan_screen.dart';
import 'package:skinaware_flutter/screens/settings_screen.dart';

class Mainpage extends ConsumerStatefulWidget {
  const Mainpage({
    super.key,
  });

  @override
  ConsumerState<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends ConsumerState<Mainpage> {
  int _currentIndex = 0;

  List<Widget> _getPages() {
    return [
      HomeScreen(),
      HomeScreen(), // TODO: Replace with Reports screen
      const ScanScreen(),
      const SettingsScreen(),
    ];
  }

  SvgPicture _svgIcon(String src, {Color? color}) {
    return SvgPicture.asset(
      src,
      height: 24,
      colorFilter: ColorFilter.mode(
        color ??
            Theme.of(context).iconTheme.color!.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.3 : 1,
            ),
        BlendMode.srcIn,
      ),
    );
  }

  Widget _buildProfileIcon(BuildContext context, {bool isActive = false}) {
    final imageUrl =
        "https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=761&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.light
                ? primaryColor
                : whileColor80,
            width: 1.5,
          ),
        ),
        child: CircleAvatar(
          radius: isActive ? 14 : 12,
          backgroundImage: CachedNetworkImageProvider(imageUrl),
          backgroundColor: Colors.grey.shade200,
          onBackgroundImageError: (exception, stackTrace) {
            AssetImage("assets/images/user.png");
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = 1;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                scrolledUnderElevation: 0.0,
                automaticallyImplyLeading: false,
                floating: true,
                snap: true,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, profilePageRoute);
                  },
                  child: _buildProfileIcon(context),
                ),
                title: Text(
                  'Hello, Sarah Minpole👋',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                    height: 1.2,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      LucideIcons.bell,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ],
              ),
            ];
          },
          body: PageTransitionSwitcher(
            duration: defaultDuration,
            transitionBuilder: (child, animation, secondaryAnimation) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: _getPages()[_currentIndex],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final unreadChats = 2;
    return Container(
      padding: const EdgeInsets.only(top: defaultPadding / 2),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        selectedItemColor: Theme.of(context).brightness == Brightness.light
            ? primaryColor
            : whileColor80,
        unselectedItemColor: Colors.transparent,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              LucideIcons.home,
              color: const Color.fromARGB(255, 209, 210, 214),
            ),
            activeIcon: Icon(LucideIcons.home, color: primaryColor),

            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              LucideIcons.pieChart,
              color: const Color.fromARGB(255, 209, 210, 214),
            ),
            activeIcon: Icon(LucideIcons.pieChart, color: primaryColor),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              LucideIcons.scanFace,
              color: const Color.fromARGB(255, 209, 210, 214),
            ),
            activeIcon: Icon(LucideIcons.scanFace, color: primaryColor),
            label: "Scan",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              LucideIcons.settings,
              color: const Color.fromARGB(255, 209, 210, 214),
            ),
            activeIcon: Icon(LucideIcons.settings, color: primaryColor),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
