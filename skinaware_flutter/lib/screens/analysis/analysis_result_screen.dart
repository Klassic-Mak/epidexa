import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/ai/gemini_service.dart';
import '../../routes/route_constants.dart';

class AnalysisResultScreen extends ConsumerWidget {
  static const primaryColor = Color(0xFF0284C7);

  final String imagePath;
  final AnalysisResult? result;

  const AnalysisResultScreen({
    super.key,
    required this.imagePath,
    this.result,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasResult = result != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Result',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF0F172A)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon')),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ImageHero(path: imagePath),
            const SizedBox(height: 14),
            if (!hasResult) ...[
              const _LoadingCard(),
              const SizedBox(height: 14),
            ] else ...[
              _DiagnosisCard(
                diagnosis: result!.diagnosis,
                confidence: result!.confidence,
              ),
              const SizedBox(height: 14),
              _RecommendationsCard(text: result!.recommendations),
              const SizedBox(height: 14),
              if (result!.requiresUrgentCare) _UrgentCard(),
              if (result!.requiresUrgentCare) const SizedBox(height: 14),
            ],
            _Actions(
              onAskMore: () => Navigator.pushNamed(context, chatRoute),
              onNewScan: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
            const _FooterNote(),
          ],
        ),
      ),
    );
  }
}

class _ImageHero extends StatelessWidget {
  final String path;

  const _ImageHero({required this.path});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(
                  Icons.image_not_supported_rounded,
                  size: 46,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.38),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.14)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.photo_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Captured image',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
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
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: AnalysisResultScreen.primaryColor,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Dr. Epi is analyzing…',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagnosisCard extends StatelessWidget {
  final String diagnosis;
  final double confidence;

  const _DiagnosisCard({
    required this.diagnosis,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (confidence * 100).clamp(0, 100).toStringAsFixed(0);
    final level = _confidenceLevel(confidence);
    final tone = _confidenceTone(level);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
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
                  color: AnalysisResultScreen.primaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AnalysisResultScreen.primaryColor.withOpacity(0.18),
                  ),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: AnalysisResultScreen.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Clinical impression',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w900,
                    fontSize: 15.5,
                  ),
                ),
              ),
              _Pill(
                text: '$pct%',
                bg: tone.bg,
                fg: tone.fg,
                border: tone.border,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            diagnosis,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(tone.icon, color: tone.fg, size: 16),
              const SizedBox(width: 8),
              Text(
                'Confidence: ${_confidenceLabel(level)}',
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static _ConfidenceLevel _confidenceLevel(double c) {
    if (c >= 0.8) return _ConfidenceLevel.high;
    if (c >= 0.6) return _ConfidenceLevel.medium;
    return _ConfidenceLevel.low;
  }

  static String _confidenceLabel(_ConfidenceLevel level) {
    switch (level) {
      case _ConfidenceLevel.high:
        return 'High';
      case _ConfidenceLevel.medium:
        return 'Medium';
      case _ConfidenceLevel.low:
        return 'Low';
    }
  }

  static _Tone _confidenceTone(_ConfidenceLevel level) {
    switch (level) {
      case _ConfidenceLevel.high:
        return const _Tone(
          bg: Color(0xFFECFDF5),
          fg: Color(0xFF16A34A),
          border: Color(0xFFBBF7D0),
          icon: Icons.verified_rounded,
        );
      case _ConfidenceLevel.medium:
        return const _Tone(
          bg: Color(0xFFFFFBEB),
          fg: Color(0xFFF59E0B),
          border: Color(0xFFFDE68A),
          icon: Icons.info_rounded,
        );
      case _ConfidenceLevel.low:
        return const _Tone(
          bg: Color(0xFFFEF2F2),
          fg: Color(0xFFDC2626),
          border: Color(0xFFFECACA),
          icon: Icons.error_outline_rounded,
        );
    }
  }
}

enum _ConfidenceLevel { high, medium, low }

class _Tone {
  final Color bg;
  final Color fg;
  final Color border;
  final IconData icon;

  const _Tone({
    required this.bg,
    required this.fg,
    required this.border,
    required this.icon,
  });
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final Color border;

  const _Pill({
    required this.text,
    required this.bg,
    required this.fg,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w900,
          fontSize: 12.5,
        ),
      ),
    );
  }
}

class _RecommendationsCard extends StatelessWidget {
  final String text;

  const _RecommendationsCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
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
                  color: AnalysisResultScreen.primaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AnalysisResultScreen.primaryColor.withOpacity(0.18),
                  ),
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: AnalysisResultScreen.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Recommendations',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w900,
                    fontSize: 15.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(
            text,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 14.6,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _UrgentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFDC2626),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seek medical care',
                  style: TextStyle(
                    color: Color(0xFF991B1B),
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'This result suggests you should see a dermatologist as soon as possible.',
                  style: TextStyle(
                    color: Color(0xFF991B1B),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
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

class _Actions extends StatelessWidget {
  final VoidCallback onAskMore;
  final VoidCallback onNewScan;

  const _Actions({
    required this.onAskMore,
    required this.onNewScan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onAskMore,
            style: ElevatedButton.styleFrom(
              backgroundColor: AnalysisResultScreen.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline_rounded, size: 20),
                SizedBox(width: 10),
                Text(
                  'Ask Dr. Epi more',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onNewScan,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0F172A),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined, size: 20),
                SizedBox(width: 10),
                Text(
                  'Analyze another image',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF64748B), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'This is an AI-assisted suggestion and not a medical diagnosis. If symptoms worsen or you feel unwell, please seek professional care.',
              style: TextStyle(
                color: Color(0xFF475569),
                fontWeight: FontWeight.w600,
                height: 1.35,
                fontSize: 12.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
