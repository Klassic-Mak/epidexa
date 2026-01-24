import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import '../providers/chat_provider.dart';
import '../routes/route_constants.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  List<String> selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();
  bool _isAnalyzing = false;

  Future<void> _takePhoto() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        selectedImages.add(image.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final List<XFile> images = await _imagePicker.pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images.map((x) => x.path));
      });
    }
  }

  Future<void> _analyzeImages() async {
    if (selectedImages.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final result = await ref
          .read(analysisProvider.notifier)
          .analyzeSelectedImages(
            symptoms: null,
            duration: null,
          );

      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });

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
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis error: $e')),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final analysisState = ref.read(analysisProvider);
    if (analysisState.selectedImages.isNotEmpty && selectedImages.isEmpty) {
      setState(() {
        selectedImages = List.from(analysisState.selectedImages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysisState = ref.watch(analysisProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Skin Analysis',
          style: TextStyle(
            color: Color(0xFF2C7A9B),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF2C7A9B),
            ),
            onPressed: () => Navigator.pushNamed(context, chatRoute),
            tooltip: 'Ask Dr. Epi',
          ),
          if (selectedImages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFF2C7A9B)),
              onPressed: () {
                setState(() {
                  selectedImages.clear();
                });
                ref.read(analysisProvider.notifier).clearImages();
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 16),
                _buildCameraOption(),
                const SizedBox(height: 12),
                _buildUploadOption(),
                if (selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSelectedImagesSection(),
                ],
                const SizedBox(height: 16),
                _buildTipsSection(),
                if (selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildAnalyzeButton(),
                ],
                const SizedBox(height: 16),
                _buildQuickChatSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (_isAnalyzing || analysisState.isAnalyzing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Color(0xFF2C7A9B),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Dr. Epi is analyzing...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C7A9B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please wait a moment',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
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

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C7A9B), Color(0xFF7DD3C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C7A9B).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Capture or Upload',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Take a clear photo of the skin area to analyze\nor select from photo library',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraOption() {
    return InkWell(
      onTap: _takePhoto,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF2C7A9B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Color(0xFF2C7A9B),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Take Photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Use camera to capture',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF2C7A9B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption() {
    return InkWell(
      onTap: _pickFromGallery,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF7DD3C0).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.photo_library_rounded,
                color: Color(0xFF2C7A9B),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload from Library',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Select one or more photos',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF2C7A9B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Selected photos',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              _countPill(selectedImages.length),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedImages.clear();
                  });
                  ref.read(analysisProvider.notifier).clearImages();
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(selectedImages[index]),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: Color(0xFF2C7A9B),
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImages.removeAt(index);
                        });
                        ref.read(analysisProvider.notifier).removeImage(index);
                      },
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          shape: BoxShape.circle,
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
          ),
        ],
      ),
    );
  }

  Widget _countPill(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: primaryColor,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF9DD9F3).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: Color(0xFF2C7A9B),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Photo tips',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            Icons.wb_sunny_outlined,
            'Good Lighting',
            'Use natural light or bright lamp',
            const Color(0xFFFFA07A),
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            Icons.center_focus_strong,
            'Clear Focus',
            'Keep camera steady and focus on the area',
            const Color(0xFF7DD3C0),
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            Icons.straighten,
            'Proper Distance',
            'Capture 15-30cm from skin',
            const Color(0xFF9DD9F3),
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            Icons.crop_free,
            'Fill Frame',
            'Ensure skin area fills most of the frame',
            const Color(0xFF87CEEB),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(
    IconData icon,
    String title,
    String description,
    Color iconColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2C7A9B), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isAnalyzing
            ? null
            : () {
                for (final path in selectedImages) {
                  ref.read(analysisProvider.notifier).addImage(path);
                }
                _analyzeImages();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C7A9B),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.analytics_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              'Analyze ${selectedImages.length} ${selectedImages.length == 1 ? 'photo' : 'photos'}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChatSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2C7A9B).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2C7A9B), Color(0xFF7DD3C0)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ask Dr. Epi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C7A9B),
                      ),
                    ),
                    Text(
                      'Direct dermatology consultation with AI',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, chatRoute),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Start Consultation'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2C7A9B),
                side: const BorderSide(color: Color(0xFF2C7A9B)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
