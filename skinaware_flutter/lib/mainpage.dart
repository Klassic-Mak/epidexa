// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skinaware_flutter/constants.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';
import 'package:skinaware_flutter/screens/homeScreen/home_screen.dart';

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
    final isSeller = true;
    return [
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
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
    final imageUrl = "https://randomuser.me/api/portraits/women/2.jpg";
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
                title: SvgPicture.asset(
                  "assets/icons/logo_black.svg",
                  height: 35,
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, profilePageRoute);
                    },
                    child: _buildProfileIcon(context),
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
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
          }
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
              Icons.home_rounded,
              color: const Color.fromARGB(255, 209, 210, 214),
            ),
            activeIcon: Icon(Icons.home_rounded, color: primaryColor),

            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.history_rounded,
              color: const Color.fromARGB(255, 209, 210, 214),
            ),
            activeIcon: Icon(Icons.history_rounded, color: primaryColor),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark_rounded,
              color: const Color.fromARGB(255, 209, 210, 214),
            ),
            activeIcon: Icon(
              Icons.bookmark_rounded,
              color: primaryColor,
            ),
            label: "Saved",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_rounded,
              color: const Color.fromARGB(255, 209, 210, 214),
            ),
            activeIcon: Icon(Icons.settings_rounded, color: primaryColor),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
