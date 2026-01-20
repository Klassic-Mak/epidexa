import 'package:flutter/material.dart';

class SkinScanningScreen extends StatefulWidget {
  const SkinScanningScreen({super.key});

  @override
  State<SkinScanningScreen> createState() => _SkinScanningScreenState();
}

class _SkinScanningScreenState extends State<SkinScanningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}
