// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinaware_flutter/constants.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';
import 'package:skinaware_flutter/services/auth_services/auth_services.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final appScheme = 'fashionhouse';
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  late final String loginError;
  bool _isPasswordVisible = false;
  final AuthServices authService = AuthServices();
  final bool _isLoading = false;

  bool isBusy = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 22,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "Hello Again!",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  " Fill your credentials to continue to Epidexa",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: blackColor40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email Address",
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontSize: 15,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  cursorColor:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? primaryColor
                                      : Colors.white,
                                  controller: emailController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? darktextfieldboxColor
                                        : textfieldboxColor,
                                    hintText: "xyz@example.com",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: const Color.fromARGB(
                                        220,
                                        192,
                                        192,
                                        192,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(defaultBorderRadious),
                                      ),
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? darktextfieldboxColor
                                            : textfieldboxColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(defaultBorderRadious),
                                      ),
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? darktextfieldboxColor
                                            : textfieldboxColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(defaultBorderRadious),
                                      ),
                                      borderSide: BorderSide(
                                        width: 0,
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? darktextfieldboxColor
                                            : textfieldboxColor,
                                      ),
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/icons/Message.svg",
                                        height: 24,
                                        color: Theme.of(
                                          context,
                                        ).iconTheme.color!.withOpacity(0.3),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(
                                      r'^[^@]+@[^@]+\.[^@]+',
                                    ).hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => email = value!,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Password",
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontSize: 15,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  cursorColor:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? primaryColor
                                      : Colors.white,
                                  controller: passwordController,
                                  obscureText: !_isPasswordVisible,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                      icon: _isPasswordVisible
                                          ? SvgPicture.asset(
                                              "assets/icons/eye-slash.svg",
                                              color: blackColor40,
                                            )
                                          : SvgPicture.asset(
                                              "assets/icons/eye.svg",
                                              color: blackColor40,
                                            ),
                                    ),
                                    filled: true,
                                    fillColor:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? darktextfieldboxColor
                                        : textfieldboxColor,
                                    hintText: "••••••••",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: const Color.fromARGB(
                                        220,
                                        192,
                                        192,
                                        192,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(defaultBorderRadious),
                                      ),
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? darktextfieldboxColor
                                            : textfieldboxColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(defaultBorderRadious),
                                      ),
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? darktextfieldboxColor
                                            : textfieldboxColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(defaultBorderRadious),
                                      ),
                                      borderSide: BorderSide(
                                        width: 0,
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? darktextfieldboxColor
                                            : textfieldboxColor,
                                      ),
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/icons/Lock.svg",
                                        height: 24,
                                        color: Theme.of(
                                          context,
                                        ).iconTheme.color!.withOpacity(0.3),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => password = value!,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot password ?",
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontSize: 13.5,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(
                              defaultBorderRadious,
                            ),
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => isBusy = true);
                                _formKey.currentState!.save();
                                await authService.signInWithEmailPassword(
                                  email: emailController.text.toString(),

                                  password: passwordController.text,
                                  context: context,
                                  ref: ref,
                                );
                                setState(() => isBusy = false);
                              }
                              try {
                                FocusScope.of(context).unfocus();
                              } catch (_) {
                                FocusManager.instance.primaryFocus?.unfocus();
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
                                      "Sign In",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontSize: 15.5,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RichText(
                  text: TextSpan(
                    text: 'New User? ',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white54
                          : const Color.fromARGB(131, 0, 0, 0),
                      fontSize: 14.0,
                    ),
                    children: [
                      TextSpan(
                        text: 'Create Account',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, signupRoute);
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
