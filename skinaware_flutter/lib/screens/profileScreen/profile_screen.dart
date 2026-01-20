import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinaware_flutter/constants.dart';
import 'package:skinaware_flutter/general_components/divider_list_tile.dart';
import 'package:skinaware_flutter/general_components/shimmers/shimmer_widget.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String name = "Sarah Minpole";
  final String email = 'minpolesarah@gmail.com';
  final String imagesrc = "https://randomuser.me/api/portraits/women/2.jpg";
  bool isShowHi = true;
  bool isShowSeller = false;

  ProfileScreen({
    super.key,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                    name: widget.name,
                    email: widget.email,
                    imageSrc: widget.imagesrc,
                    proLableText: "Seller",
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
              "Personalization",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          DividerListTileWithTrilingText(
            svgSrc: "assets/icons/Notification.svg",
            title: "Notification",
            trilingText: "On",
            press: () {
              // Navigator.pushNamed(context, enableNotificationScreenRoute);
            },
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
            onTap: () {},
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
