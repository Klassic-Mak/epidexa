import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SkinCameraScreen extends StatefulWidget {
  const SkinCameraScreen({
    super.key,
    this.allowMultipleFromGallery = true,
  });

  final bool allowMultipleFromGallery;

  @override
  State<SkinCameraScreen> createState() => _SkinCameraScreenState();
}

class _SkinCameraScreenState extends State<SkinCameraScreen> {
  static const primaryColor = Color(0xFF0284C7);

  final ImagePicker _picker = ImagePicker();

  List<CameraDescription> _cameras = [];
  CameraController? _controller;

  bool _flashOn = false;
  bool _showGrid = false;
  bool _initializing = true;
  bool _permissionsDenied = false;
  bool _busy = false;

  double _currentZoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _boot() async {
    setState(() {
      _initializing = true;
      _permissionsDenied = false;
    });

    final ok = await _ensurePermissions();
    if (!ok) {
      setState(() {
        _permissionsDenied = true;
        _initializing = false;
      });
      return;
    }

    try {
      _cameras = await availableCameras();
      final back = _cameras
          .where((c) => c.lensDirection == CameraLensDirection.back)
          .toList();
      final chosen = back.isNotEmpty ? back.first : _cameras.first;

      await _startCamera(chosen);

      setState(() {
        _initializing = false;
      });
    } catch (_) {
      setState(() {
        _initializing = false;
        _permissionsDenied = true;
      });
    }
  }

  Future<bool> _ensurePermissions() async {
    final cam = await Permission.camera.request();

    PermissionStatus media;
    if (Platform.isIOS) {
      media = await Permission.photos.request();
    } else {
      media = await Permission.photos.request();
      if (!media.isGranted) {
        media = await Permission.storage.request();
      }
    }

    final granted = cam.isGranted;
    return granted;
  }

  Future<void> _startCamera(CameraDescription description) async {
    await _controller?.dispose();

    final controller = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _controller = controller;

    await controller.initialize();

    _minZoom = await controller.getMinZoomLevel();
    _maxZoom = await controller.getMaxZoomLevel();
    _currentZoom = _minZoom;

    await controller.setZoomLevel(_currentZoom);
    await controller.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    await controller.setFocusMode(FocusMode.auto);
    await controller.setExposureMode(ExposureMode.auto);

    if (mounted) setState(() {});
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    setState(() => _flashOn = !_flashOn);
    try {
      await _controller!.setFlashMode(
        _flashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (_) {}
  }

  void _toggleGrid() => setState(() => _showGrid = !_showGrid);

  Future<void> _switchCamera() async {
    if (_busy || _cameras.isEmpty) return;
    if (_controller == null) return;

    setState(() => _busy = true);

    try {
      final current = _controller!.description;
      final idx = _cameras.indexWhere((c) => c.name == current.name);
      final next = _cameras[(idx + 1) % _cameras.length];
      await _startCamera(next);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickFromGallery() async {
    if (_busy) return;

    setState(() => _busy = true);
    try {
      if (widget.allowMultipleFromGallery) {
        final files = await _picker.pickMultiImage(imageQuality: 92);
        if (!mounted) return;
        if (files.isNotEmpty) {
          Navigator.pop(context, files.map((e) => e.path).toList());
          return;
        }
      } else {
        final file = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 92,
        );
        if (!mounted) return;
        if (file != null) {
          Navigator.pop(context, [file.path]);
          return;
        }
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null) return;
    if (_busy) return;
    if (!controller.value.isInitialized) return;

    setState(() => _busy = true);

    try {
      await controller.setFocusMode(FocusMode.auto);
      final xfile = await controller.takePicture();
      if (!mounted) return;
      Navigator.pop(context, [xfile.path]);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not capture photo. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _retryPermissions() async {
    final cam = await Permission.camera.status;
    if (cam.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }
    await _boot();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _permissionsDenied
                ? _PermissionsView(onTap: _retryPermissions)
                : (controller == null ||
                      _initializing ||
                      !controller.value.isInitialized)
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : CameraPreview(controller),
          ),

          if (_showGrid && !_permissionsDenied)
            Positioned.fill(child: _GridOverlay()),

          if (!_permissionsDenied)
            Positioned.fill(
              child: _CutoutOverlay(
                borderRadius: 24,
                strokeWidth: 3,
                cutoutWidthFactor: 0.78,
                cutoutHeightFactor: 0.42,
                strokeColor: primaryColor,
                dimColor: Colors.black.withOpacity(0.55),
              ),
            ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Row(
                children: [
                  _topIconButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.maybePop(context),
                  ),
                  const Spacer(),
                  _topIconButton(
                    icon: _flashOn
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    onTap: _toggleFlash,
                    active: _flashOn,
                    disabled: _permissionsDenied || _initializing,
                  ),
                  const SizedBox(width: 10),
                  _topIconButton(
                    icon: _showGrid
                        ? Icons.grid_on_rounded
                        : Icons.grid_off_rounded,
                    onTap: _toggleGrid,
                    active: _showGrid,
                    disabled: _permissionsDenied || _initializing,
                  ),
                ],
              ),
            ),
          ),

          if (!_permissionsDenied)
            Positioned(
              top: MediaQuery.of(context).padding.top + 64,
              left: 16,
              right: 16,
              child: _GlassCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.center_focus_strong_rounded,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Center the affected area',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Keep the skin inside the frame. Use good lighting and avoid blur.',
                            style: TextStyle(
                              color: Color(0xFFE5E7EB),
                              fontSize: 12.5,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (!_permissionsDenied) _GuideLabels(primaryColor: primaryColor),

          if (!_permissionsDenied &&
              controller != null &&
              controller.value.isInitialized)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_permissionsDenied)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _miniHint(
                              icon: Icons.wb_sunny_rounded,
                              text: "Light",
                            ),
                            const SizedBox(width: 10),
                            _miniHint(
                              icon: Icons.front_hand_rounded,
                              text: "Steady",
                            ),
                            const SizedBox(width: 10),
                            _miniHint(
                              icon: Icons.straighten_rounded,
                              text: "6–12 in",
                            ),
                          ],
                        ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _roundAction(
                            icon: Icons.photo_library_rounded,
                            onTap:
                                (_permissionsDenied || _initializing || _busy)
                                ? null
                                : _pickFromGallery,
                          ),
                          const Spacer(),
                          _shutterButton(
                            onTap:
                                (_permissionsDenied || _initializing || _busy)
                                ? null
                                : _capture,
                            busy: _busy,
                          ),
                          const Spacer(),
                          _roundAction(
                            icon: Icons.cameraswitch_rounded,
                            onTap:
                                (_permissionsDenied || _initializing || _busy)
                                ? null
                                : _switchCamera,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _topIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool active = false,
    bool disabled = false,
  }) {
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Opacity(
        opacity: disabled ? 0.45 : 1,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(active ? 0.16 : 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(active ? 0.20 : 0.12),
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _miniHint({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFFE5E7EB),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundAction({required IconData icon, required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Opacity(
        opacity: onTap == null ? 0.45 : 1,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _shutterButton({required VoidCallback? onTap, required bool busy}) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.45 : 1,
        child: Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.12),
            border: Border.all(color: Colors.white.withOpacity(0.22), width: 2),
          ),
          child: Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  child: busy
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionsView extends StatelessWidget {
  final VoidCallback onTap;
  const _PermissionsView({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF050A14),
      padding: const EdgeInsets.all(22),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Camera permission needed',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enable camera access to take a clear photo of the affected area.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Enable permission',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
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

class _CutoutOverlay extends StatelessWidget {
  final double borderRadius;
  final double strokeWidth;
  final double cutoutWidthFactor;
  final double cutoutHeightFactor;
  final Color strokeColor;
  final Color dimColor;

  const _CutoutOverlay({
    required this.borderRadius,
    required this.strokeWidth,
    required this.cutoutWidthFactor,
    required this.cutoutHeightFactor,
    required this.strokeColor,
    required this.dimColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CutoutPainter(
        borderRadius: borderRadius,
        strokeWidth: strokeWidth,
        cutoutWidthFactor: cutoutWidthFactor,
        cutoutHeightFactor: cutoutHeightFactor,
        strokeColor: strokeColor,
        dimColor: dimColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _CutoutPainter extends CustomPainter {
  final double borderRadius;
  final double strokeWidth;
  final double cutoutWidthFactor;
  final double cutoutHeightFactor;
  final Color strokeColor;
  final Color dimColor;

  _CutoutPainter({
    required this.borderRadius,
    required this.strokeWidth,
    required this.cutoutWidthFactor,
    required this.cutoutHeightFactor,
    required this.strokeColor,
    required this.dimColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintDim = Paint()..color = dimColor;

    final cutoutW = size.width * cutoutWidthFactor;
    final cutoutH = size.height * cutoutHeightFactor;

    final cutoutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.47),
      width: cutoutW,
      height: cutoutH,
    );

    final cutoutRRect = RRect.fromRectAndRadius(
      cutoutRect,
      Radius.circular(borderRadius),
    );

    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()..addRRect(cutoutRRect);

    final overlay = Path.combine(PathOperation.difference, fullPath, holePath);
    canvas.drawPath(overlay, paintDim);

    final paintStroke = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(cutoutRRect, paintStroke);

    final accent = Paint()
      ..color = Colors.white.withOpacity(0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const cornerLen = 18.0;
    final r = cutoutRect;

    canvas.drawLine(
      Offset(r.left, r.top + 10),
      Offset(r.left, r.top + 10 + cornerLen),
      accent,
    );
    canvas.drawLine(
      Offset(r.left + 10, r.top),
      Offset(r.left + 10 + cornerLen, r.top),
      accent,
    );

    canvas.drawLine(
      Offset(r.right, r.top + 10),
      Offset(r.right, r.top + 10 + cornerLen),
      accent,
    );
    canvas.drawLine(
      Offset(r.right - 10, r.top),
      Offset(r.right - 10 - cornerLen, r.top),
      accent,
    );

    canvas.drawLine(
      Offset(r.left, r.bottom - 10),
      Offset(r.left, r.bottom - 10 - cornerLen),
      accent,
    );
    canvas.drawLine(
      Offset(r.left + 10, r.bottom),
      Offset(r.left + 10 + cornerLen, r.bottom),
      accent,
    );

    canvas.drawLine(
      Offset(r.right, r.bottom - 10),
      Offset(r.right, r.bottom - 10 - cornerLen),
      accent,
    );
    canvas.drawLine(
      Offset(r.right - 10, r.bottom),
      Offset(r.right - 10 - cornerLen, r.bottom),
      accent,
    );
  }

  @override
  bool shouldRepaint(covariant _CutoutPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cutoutWidthFactor != cutoutWidthFactor ||
        oldDelegate.cutoutHeightFactor != cutoutHeightFactor ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.dimColor != dimColor;
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GridOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1;

    final thirdW = size.width / 3;
    final thirdH = size.height / 3;

    canvas.drawLine(Offset(thirdW, 0), Offset(thirdW, size.height), paint);
    canvas.drawLine(
      Offset(thirdW * 2, 0),
      Offset(thirdW * 2, size.height),
      paint,
    );
    canvas.drawLine(Offset(0, thirdH), Offset(size.width, thirdH), paint);
    canvas.drawLine(
      Offset(0, thirdH * 2),
      Offset(size.width, thirdH * 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GuideLabels extends StatelessWidget {
  final Color primaryColor;
  const _GuideLabels({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cutoutW = size.width * 0.78;
    final cutoutH = size.height * 0.42;
    final top = size.height * 0.47 - cutoutH / 2;

    return Positioned(
      top: top - 34,
      left: (size.width - cutoutW) / 2,
      right: (size.width - cutoutW) / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      ),
    );
  }

  Widget _labelPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: const Text(
        ' ',
        style: TextStyle(fontSize: 0),
      ),
    ).copyWithText(text);
  }
}

extension on Widget {
  Widget copyWithText(String text) {
    if (this is Container) {
      final c = this as Container;
      return Container(
        padding: c.padding,
        decoration: c.decoration,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFE5E7EB),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      );
    }
    return this;
  }
}
