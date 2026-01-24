import 'package:flutter/material.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  static const primaryColor = Color(0xFF0284C7);

  final List<String> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    final hasImages = selectedImages.isNotEmpty;

    return Scaffold(
      bottomNavigationBar: hasImages ? _buildBottomAnalyzeBar() : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              _buildHeaderSection(),
              const SizedBox(height: 14),

              _buildActionGrid(),
              const SizedBox(height: 14),

              if (hasImages) ...[
                _buildSelectedImagesSection(),
                const SizedBox(height: 14),
              ],

              _buildTipsSection(),

              SizedBox(height: hasImages ? 96 : 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.pushNamed(context, camerScanRoute);
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.camera_alt_rounded, color: primaryColor),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Capture or upload',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Take a clear photo of the affected area or select from your gallery.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid() {
    return Row(
      children: [
        Expanded(
          child: _actionCard(
            icon: Icons.camera_alt_rounded,
            title: 'Take photo',
            subtitle: 'Open camera',
            onTap: () => _showComingSoonDialog('Camera'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionCard(
            icon: Icons.photo_library_rounded,
            title: 'Upload',
            subtitle: 'From gallery',
            onTap: () => _showComingSoonDialog('Gallery Upload'),
          ),
        ),
      ],
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
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
              child: Icon(icon, color: primaryColor),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Selected photos',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              _countPill(selectedImages.length),
              const Spacer(),
              TextButton(
                onPressed: () => setState(selectedImages.clear),
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                child: const Text(
                  'Clear',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
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
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_rounded,
                        color: Color(0xFF94A3B8),
                        size: 34,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => selectedImages.removeAt(index)),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
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
        color: primaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primaryColor.withOpacity(0.25)),
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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                  color: primaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.lightbulb_rounded, color: primaryColor),
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
          const SizedBox(height: 14),

          _tipRow(
            icon: Icons.wb_sunny_rounded,
            title: 'Good lighting',
            subtitle: 'Prefer natural light or bright indoor lighting.',
          ),
          const SizedBox(height: 12),
          _tipRow(
            icon: Icons.center_focus_strong_rounded,
            title: 'Keep it sharp',
            subtitle: 'Hold steady and focus on the affected area.',
          ),
          const SizedBox(height: 12),
          _tipRow(
            icon: Icons.straighten_rounded,
            title: 'Distance',
            subtitle: 'Take the photo about 6–12 inches away.',
          ),
          const SizedBox(height: 12),
          _tipRow(
            icon: Icons.crop_free_rounded,
            title: 'Fill the frame',
            subtitle: 'Let the affected area take most of the photo.',
          ),
        ],
      ),
    );
  }

  Widget _tipRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Icon(icon, color: primaryColor, size: 20),
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
                subtitle,
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

  Widget _buildBottomAnalyzeBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: const Color(0xFFE5E7EB))),
        ),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () => _showComingSoonDialog('Analysis'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
        ),
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Coming soon'),
        content: Text('$feature will be implemented next.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
