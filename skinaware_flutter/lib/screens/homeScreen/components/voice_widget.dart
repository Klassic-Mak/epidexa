import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:skinaware_flutter/constants.dart';
import 'package:wave_blob/wave_blob.dart';

class VoiceWidget extends StatefulWidget {
  final TextEditingController requestController;
  final GlobalKey<FormState> requestFormKey;
  final VoidCallback onCall;

  const VoiceWidget({
    super.key,
    required this.requestController,
    required this.requestFormKey,
    required this.onCall,
  });

  @override
  State<VoiceWidget> createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends State<VoiceWidget> {
  bool _isListening = false;

  double _scale = 1.0;
  double _amplitude = 20.0;
  double _t = 0;

  Timer? _timer;

  void _startListening() {
    if (_isListening) return;

    _isListening = true;
    widget.onCall();

    _timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!mounted) return;

      _t += 0.1;
      setState(() {
        _scale = 1.3;
        _amplitude = 4250.0;
      });
    });
  }

  void _stopListening() {
    if (!_isListening) return;

    _isListening = false;
    _timer?.cancel();
    _timer = null;

    setState(() {
      _scale = 1.0;
      _amplitude = 20.0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width * 0.6;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Tap to speak or type below',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            /// 🎙️ MIC + WAVE
            GestureDetector(
              onTap: () {
                _isListening ? _stopListening() : _startListening();
              },
              child: SizedBox(
                width: size,
                height: size,
                child: WaveBlob(
                  blobCount: 6,
                  amplitude: _amplitude,
                  scale: _scale,
                  autoScale: false,
                  centerCircle: true,
                  overCircle: true,
                  circleColors: const [
                    Color(0xFFFFE2A9),
                  ],
                  colors: const [
                    Color(0xFFFFE2A9),
                    Color(0xFFF5B23C),
                  ],
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              _isListening ? 'Listening...' : 'Press or tap to speak',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
            ),

            const SizedBox(height: 24),

            /// ⌨️ INPUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: widget.requestFormKey,
                child: TextFormField(
                  controller: widget.requestController,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.keyboard_rounded,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send_rounded, color: darkBlueColor),
                      onPressed: () {},
                    ),
                    hintText: "Type your request here...",
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? darktextfieldboxColor
                        : textfieldboxColor,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(220, 192, 192, 192),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(defaultBorderRadious),
                      ),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? darktextfieldboxColor
                            : textfieldboxColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(defaultBorderRadious),
                      ),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
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
                        color: Theme.of(context).brightness == Brightness.dark
                            ? darktextfieldboxColor
                            : textfieldboxColor,
                      ),
                    ),
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
