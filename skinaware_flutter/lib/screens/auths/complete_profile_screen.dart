// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:skinaware_client/skinaware_client.dart';
import 'package:skinaware_flutter/constants.dart';
import 'package:skinaware_flutter/general_components/loading_dialog.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';
import 'package:skinaware_flutter/services/user_services.dart';
import 'package:skinaware_flutter/providers/userProvider.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isBusy = false;

  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Gender? selectedGender;
  SkinType? selectedSkinType;

  @override
  void dispose() {
    ageController.dispose();
    phoneController.dispose();
    super.dispose();
  }

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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fillColor = isDark ? darktextfieldboxColor : textfieldboxColor;
    final iconColor = isDark
        ? Colors.white.withOpacity(0.45)
        : primaryColor.withOpacity(0.45);

    InputDecoration baseDecoration({
      required String hintText,
      required IconData icon,
      Widget? suffix,
    }) {
      return InputDecoration(
        suffixIcon: suffix,
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: const Color.fromARGB(220, 192, 192, 192),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(defaultBorderRadious),
          ),
          borderSide: BorderSide(color: fillColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(defaultBorderRadious),
          ),
          borderSide: BorderSide(color: fillColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(defaultBorderRadious),
          ),
          borderSide: BorderSide(width: 1.2, color: primaryColor),
        ),
        prefixIcon: Icon(icon, size: 20, color: iconColor),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      );
    }

    // Modern dropdown decorator: no ugly underline, nicer padding + icon
    InputDecoration dropdownDecoration({
      required String hintText,
      required IconData icon,
    }) {
      return baseDecoration(
        hintText: hintText,
        icon: icon,
      ).copyWith(
        // More consistent dropdown spacing
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 6),
                    Text(
                      "Complete your profile",
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Tell us a bit more so we can personalize your skin insights.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: blackColor40,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AGE
                    _FieldLabel("Age"),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: ageController,
                      cursorColor: isDark ? Colors.white : primaryColor,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: baseDecoration(
                        hintText: "e.g. 21",
                        icon: LucideIcons.user,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your age";
                        }
                        final n = int.tryParse(value.trim());
                        if (n == null) return "Age must be a number";
                        if (n < 1 || n > 120) return "Enter a valid age";
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    // PHONE
                    _FieldLabel("Telephone"),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: phoneController,
                      cursorColor: isDark ? Colors.white : primaryColor,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: baseDecoration(
                        hintText: "e.g. +233 55 123 4567",
                        icon: LucideIcons.phone,
                      ),
                      validator: (value) {
                        final v = value?.trim() ?? "";
                        if (v.isEmpty) return "Please enter your phone";
                        if (v.length < 7) return "Invalid phone number";
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    // GENDER (Modern dropdown)
                    _FieldLabel("Gender"),
                    SizedBox(height: 8),
                    DropdownButtonFormField<Gender>(
                      value: selectedGender,
                      decoration: dropdownDecoration(
                        hintText: "Select gender",
                        icon: LucideIcons.users,
                      ),
                      icon: Icon(
                        LucideIcons.chevronDown,
                        size: 18,
                        color: Colors.black45,
                      ),
                      dropdownColor: isDark
                          ? const Color(0xFF1C1C1C)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(defaultBorderRadious),
                      isExpanded: true,
                      items: Gender.values.map((g) {
                        final label = switch (g) {
                          Gender.MALE => "Male",
                          Gender.FEMALE => "Female",
                        };
                        return DropdownMenuItem(
                          value: g,
                          child: Text(
                            label,
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: isBusy
                          ? null
                          : (v) => setState(() => selectedGender = v),
                      validator: (v) =>
                          v == null ? "Please select gender" : null,
                    ),
                    SizedBox(height: 15),

                    // SKIN TYPE (Modern dropdown)
                    _FieldLabel("Skin Type"),
                    SizedBox(height: 8),
                    DropdownButtonFormField<SkinType>(
                      value: selectedSkinType,
                      decoration: dropdownDecoration(
                        hintText: "Select skin type",
                        icon: LucideIcons.activity,
                      ),
                      icon: Icon(
                        LucideIcons.chevronDown,
                        size: 18,
                        color: Colors.black45,
                      ),
                      dropdownColor: isDark
                          ? const Color(0xFF1C1C1C)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(defaultBorderRadious),
                      isExpanded: true,
                      items: SkinType.values.map((s) {
                        final label = switch (s) {
                          SkinType.NORMAL => "Normal Skin",
                          SkinType.DRY => "Dry Skin",
                          SkinType.OILY => "Oily Skin",
                          SkinType.COMBINATION => "Combination Skin",
                          SkinType.SENSITIVE => "Sensitive Skin",
                        };
                        return DropdownMenuItem(
                          value: s,
                          child: Text(
                            label,
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: isBusy
                          ? null
                          : (v) => setState(() => selectedSkinType = v),
                      validator: (v) =>
                          v == null ? "Please select skin type" : null,
                    ),
                    SizedBox(height: 24),

                    // SAVE BUTTON (No in-button loader; use LoadingDialog only)
                    InkWell(
                      borderRadius: BorderRadius.circular(defaultBorderRadious),
                      onTap: isBusy
                          ? null
                          : () async {
                              // Use FocusScope to safely unfocus even if no Focus widget is present
                              try {
                                FocusScope.of(context).unfocus();
                              } catch (_) {
                                // fallback
                                FocusManager.instance.primaryFocus?.unfocus();
                              }

                              if (!_formKey.currentState!.validate()) return;

                              final age = int.parse(ageController.text);
                              final phone = phoneController.text.trim();
                              final gender = selectedGender!;
                              final skinType = selectedSkinType!;

                              final currentUser = ref.read(userProvider);
                              if (currentUser == null ||
                                  currentUser.id == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No authenticated user. Please log in.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              setState(() => isBusy = true);

                              try {
                                // ✅ Show your global loader
                                LoadingDialog.show(context);

                                await UserServices().updateUser(
                                  context: context,
                                  ref: ref,
                                  userId: currentUser.id!,
                                  age: age,
                                  phone: phone,
                                  gender: gender,
                                  skinType: skinType,
                                );

                                if (!mounted) return;

                                // ✅ Close loader (your LoadingDialog uses Navigator.pop)
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                }

                                Navigator.pushReplacementNamed(
                                  context,
                                  mainPageRoute,
                                );
                              } catch (e) {
                                if (!mounted) return;

                                // Close loader if still open
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed: $e')),
                                );
                              } finally {
                                if (mounted) setState(() => isBusy = false);
                              }
                            },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadious,
                          ),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Save & Continue",
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontSize: 15.5,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                LucideIcons.arrowRight,
                                size: 16,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontSize: 15,
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}
