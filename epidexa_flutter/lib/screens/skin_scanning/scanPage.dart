// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class ScanTicketScreen extends StatefulWidget {
  const ScanTicketScreen({
    super.key,
    required this.eventId,
    required this.event,
    this.overrideScanType,
  });

  final String eventId;
  final dynamic event;
  final dynamic overrideScanType;

  @override
  State<ScanTicketScreen> createState() => _ScanTicketScreenState();
}

class _ScanTicketScreenState extends State<ScanTicketScreen> {
  final Color primaryColor = const Color.fromRGBO(26, 35, 46, 1.0);
  final Color secondaryColor = const Color.fromRGBO(41, 182, 246, 1.0);

  final ImagePicker _imagePicker = ImagePicker();
  bool _isFrontCamera = false;

  Future<void> _capturePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: _isFrontCamera
            ? CameraDevice.front
            : CameraDevice.rear,
      );

      if (image == null) return;

      if (!mounted) return;
      HapticFeedback.vibrate();

      // Navigate to details page with captured image path
      // await Navigator.pushNamed(
      //   context,
      //   scanDetailsPageRoute,
      //   arguments: {'eventId': widget.eventId, 'imagePath': image.path},
      // );
    } catch (e) {
      print('Error capturing photo: $e');
    }
  }

  Future<void> _switchCamera() async {
    setState(() => _isFrontCamera = !_isFrontCamera);
    _capturePhoto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.camera,
              size: 80,
              color: Colors.white.withOpacity(0.6),
            ),
            const SizedBox(height: 30),
            Text(
              'Tap the capture button below',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            _buildLargeButton(),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.name.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              'Camera Capture',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeButton() {
    return GestureDetector(
      onTap: _capturePhoto,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: secondaryColor,
          boxShadow: [
            BoxShadow(
              color: secondaryColor.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Icon(
          LucideIcons.camera,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}

// Result dialog can be used after capture
class ScanResultDialog extends StatelessWidget {
  final String imagePath;
  final VoidCallback onContinue;

  const ScanResultDialog({
    super.key,
    required this.imagePath,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.check,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 12),
            const Text(
              "Photo Captured",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              imagePath,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
              ),
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
