import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/chat_provider.dart';
import '../providers/offline_analysis_provider.dart';
import '../routes/route_constants.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  static const primaryColor = Color(0xFF0284C7);

  final ImagePicker _imagePicker = ImagePicker();
  final List<String> selectedImages = [];

  bool _isAnalyzing = false;
  bool _useOfflineMode = false;

  Future<void> _takePhoto() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 90,
    );

    if (image != null) {
      setState(() => selectedImages.add(image.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final List<XFile> images = await _imagePicker.pickMultiImage(
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 90,
    );

    if (images.isNotEmpty) {
      setState(() => selectedImages.addAll(images.map((x) => x.path)));
    }
  }

  Future<void> _analyzeImages() async {
    if (selectedImages.isEmpty) return;

    setState(() => _isAnalyzing = true);

    if (_useOfflineMode) {
      await _analyzeOffline();
    } else {
      await _analyzeOnline();
    }
  }

  Future<void> _analyzeOnline() async {
    try {
      final result = await ref
          .read(analysisProvider.notifier)
          .analyzeSelectedImages(
            symptoms: null,
            duration: null,
          );

      if (!mounted) return;

      setState(() => _isAnalyzing = false);

      if (result != null) {
        Navigator.pushNamed(
          context,
          analysisResultRoute,
          arguments: {
            'imagePath': selectedImages.first,
            'result': result,
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analysis error: $e')),
      );
    }
  }

  Future<void> _analyzeOffline() async {
    try {
      // Add images to offline provider
      ref.read(offlineAnalysisProvider.notifier).clearImages();
      for (final path in selectedImages) {
        ref.read(offlineAnalysisProvider.notifier).addImage(path);
      }

      // Run offline analysis
      final result = await ref
          .read(offlineAnalysisProvider.notifier)
          .analyzeImageOffline();

      if (!mounted) return;

      setState(() => _isAnalyzing = false);

      if (result != null) {
        Navigator.pushNamed(
          context,
          offlineAnalysisResultRoute,
          arguments: {
            'imagePath': selectedImages.first,
            'result': result,
          },
        );
      } else {
        final error = ref.read(offlineAnalysisProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Offline analysis failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Offline analysis error: $e')),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final analysisState = ref.read(analysisProvider);
    if (analysisState.selectedImages.isNotEmpty && selectedImages.isEmpty) {
      setState(() {
        selectedImages.addAll(List<String>.from(analysisState.selectedImages));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysisState = ref.watch(analysisProvider);
    final offlineState = ref.watch(offlineAnalysisProvider);
    final overlay = _isAnalyzing || analysisState.isAnalyzing || offlineState.isAnalyzing;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 30),
                _HeroCard(
                  primaryColor: primaryColor,
                  onLearnTipsTap: () => _scrollToTips(context),
                ),
                const SizedBox(height: 14),
                _OfflineModeCard(
                  isOffline: _useOfflineMode,
                  primaryColor: primaryColor,
                  onToggle: (value) => setState(() => _useOfflineMode = value),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        title: 'Take photo',
                        subtitle: 'Use the camera',
                        icon: Icons.camera_alt_rounded,
                        primaryColor: primaryColor,
                        onTap: _takePhoto,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        title: 'Upload',
                        subtitle: 'From library',
                        icon: Icons.photo_library_rounded,
                        primaryColor: primaryColor,
                        onTap: _pickFromGallery,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (selectedImages.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Selected photos',
                    trailing: _CountPill(
                      count: selectedImages.length,
                      primaryColor: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SelectedGrid(
                    images: selectedImages,
                    onRemove: (index) {
                      setState(() => selectedImages.removeAt(index));
                      ref.read(analysisProvider.notifier).removeImage(index);
                    },
                  ),
                  const SizedBox(height: 14),
                  _AnalyzeBar(
                    count: selectedImages.length,
                    primaryColor: primaryColor,
                    enabled: !overlay,
                    isOffline: _useOfflineMode,
                    onTap: () {
                      ref.read(analysisProvider.notifier).clearImages();
                      for (final p in selectedImages) {
                        ref.read(analysisProvider.notifier).addImage(p);
                      }
                      _analyzeImages();
                    },
                  ),
                  const SizedBox(height: 14),
                ],
                const _SectionHeader(title: 'Photo tips'),
                const SizedBox(height: 10),
                _TipsCard(primaryColor: primaryColor),
                const SizedBox(height: 14),
                const _SectionHeader(title: 'Ask Dr. Epi'),
                const SizedBox(height: 10),
                _ConsultCard(
                  primaryColor: primaryColor,
                  onTap: () => Navigator.pushNamed(context, chatRoute),
                ),
              ],
            ),
          ),
          if (overlay) _AnalyzingOverlay(isOffline: _useOfflineMode),
        ],
      ),
    );
  }

  void _scrollToTips(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tip: Keep the area centered and well-lit.'),
      ),
    );
  }
}

class _OfflineModeCard extends StatelessWidget {
  final bool isOffline;
  final Color primaryColor;
  final ValueChanged<bool> onToggle;

  const _OfflineModeCard({
    required this.isOffline,
    required this.primaryColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.settings_rounded, size: 18, color: Color(0xFF64748B)),
              SizedBox(width: 8),
              Text(
                'Analysis Mode',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Segmented Control
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                // Online option (left)
                Expanded(
                  child: GestureDetector(
                    onTap: () => onToggle(false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isOffline ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: !isOffline
                            ? [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud,
                            size: 18,
                            color: !isOffline ? Colors.white : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: !isOffline ? Colors.white : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Offline option (right)
                Expanded(
                  child: GestureDetector(
                    onTap: () => onToggle(true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isOffline ? const Color(0xFFD97706) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isOffline
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFD97706).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.offline_bolt,
                            size: 18,
                            color: isOffline ? Colors.white : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Offline',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isOffline ? Colors.white : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Current mode description
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isOffline
                  ? const Color(0xFFFEF3C7)
                  : primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isOffline
                    ? const Color(0xFFFDE68A)
                    : primaryColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isOffline
                            ? const Color(0xFFD97706).withOpacity(0.15)
                            : primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isOffline ? Icons.offline_bolt : Icons.cloud,
                        size: 18,
                        color: isOffline ? const Color(0xFFD97706) : primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isOffline ? 'Offline Mode Active' : 'Online Mode Active',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: isOffline
                                  ? const Color(0xFF92400E)
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isOffline
                                ? 'Fast, on-device analysis'
                                : 'Detailed AI analysis with Dr. Epi',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isOffline
                                  ? const Color(0xFFB45309)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Features list
                Row(
                  children: [
                    _ModeFeature(
                      icon: Icons.speed,
                      label: isOffline ? 'Instant' : '~5 sec',
                      isActive: true,
                      activeColor: isOffline ? const Color(0xFFD97706) : primaryColor,
                    ),
                    const SizedBox(width: 8),
                    _ModeFeature(
                      icon: isOffline ? Icons.wifi_off : Icons.wifi,
                      label: isOffline ? 'No internet' : 'Internet',
                      isActive: true,
                      activeColor: isOffline ? const Color(0xFFD97706) : primaryColor,
                    ),
                    const SizedBox(width: 8),
                    _ModeFeature(
                      icon: isOffline ? Icons.medical_information : Icons.chat,
                      label: isOffline ? 'Guidance' : 'Chat',
                      isActive: true,
                      activeColor: isOffline ? const Color(0xFFD97706) : primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeFeature extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;

  const _ModeFeature({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: activeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: activeColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: activeColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Color primaryColor;
  final VoidCallback onLearnTipsTap;

  const _HeroCard({
    required this.primaryColor,
    required this.onLearnTipsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.16)),
            ),
            child: const Icon(
              Icons.center_focus_strong_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Capture or upload a clear photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Center the affected area, avoid blur, and use bright lighting.',
                  style: TextStyle(
                    fontSize: 12.8,
                    height: 1.35,
                    color: Colors.white.withOpacity(0.92),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: onLearnTipsTap,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lightbulb_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'View tips',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: primaryColor, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _CountPill extends StatelessWidget {
  final int count;
  final Color primaryColor;

  const _CountPill({required this.count, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primaryColor.withOpacity(0.22)),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: primaryColor,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SelectedGrid extends StatelessWidget {
  final List<String> images;
  final void Function(int index) onRemove;

  const _SelectedGrid({required this.images, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(images[index]),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_rounded,
                      color: Color(0xFF94A3B8),
                      size: 34,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.62),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withOpacity(0.14)),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AnalyzeBar extends StatelessWidget {
  final int count;
  final Color primaryColor;
  final bool enabled;
  final bool isOffline;
  final VoidCallback onTap;

  const _AnalyzeBar({
    required this.count,
    required this.primaryColor,
    required this.enabled,
    required this.onTap,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isOffline ? const Color(0xFFD97706) : primaryColor;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: bgColor.withOpacity(0.40),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOffline ? Icons.offline_bolt : Icons.analytics_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              isOffline
                  ? 'Analyze offline ($count ${count == 1 ? 'photo' : 'photos'})'
                  : 'Analyze $count ${count == 1 ? 'photo' : 'photos'}',
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  final Color primaryColor;

  const _TipsCard({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: const [
          _TipRow(
            icon: Icons.wb_sunny_rounded,
            title: 'Good lighting',
            desc: 'Use natural light or a bright lamp.',
          ),
          SizedBox(height: 12),
          _TipRow(
            icon: Icons.center_focus_strong_rounded,
            title: 'Sharp focus',
            desc: 'Hold steady and tap to focus if needed.',
          ),
          SizedBox(height: 12),
          _TipRow(
            icon: Icons.straighten_rounded,
            title: 'Proper distance',
            desc: 'Keep about 15-30 cm from the skin.',
          ),
          SizedBox(height: 12),
          _TipRow(
            icon: Icons.crop_free_rounded,
            title: 'Fill the frame',
            desc: 'Let the affected area take most of the photo.',
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _TipRow({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Icon(icon, color: _ScanScreenState.primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                desc,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.8,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConsultCard extends StatelessWidget {
  final Color primaryColor;
  final VoidCallback onTap;

  const _ConsultCard({
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.72)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.medical_services_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chat consultation',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ask questions and get guidance from Dr. Epi.',
                    style: TextStyle(
                      fontSize: 12.8,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primaryColor.withOpacity(0.18)),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyzingOverlay extends StatelessWidget {
  final bool isOffline;

  const _AnalyzingOverlay({this.isOffline = false});

  @override
  Widget build(BuildContext context) {
    final color = isOffline ? const Color(0xFFD97706) : _ScanScreenState.primaryColor;

    return Container(
      color: Colors.black.withOpacity(0.45),
      child: Center(
        child: Container(
          width: 290,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                isOffline ? 'Analyzing offline...' : 'Analyzing...',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isOffline
                    ? 'Using on-device AI model. This is quick and works without internet.'
                    : 'Dr. Epi is reviewing your photo. This may take a moment.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
