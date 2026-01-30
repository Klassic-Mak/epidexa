import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../config/model_config.dart';

class ImagePreprocessor {
  static Future<List<List<List<List<double>>>>> preprocessImage(
    String imagePath,
  ) async {
    final imageFile = File(imagePath);
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final resized = img.copyResize(
      image,
      width: ModelConfig.inputImageWidth,
      height: ModelConfig.inputImageHeight,
    );

    final input = List.generate(
      1,
      (_) => List.generate(
        ModelConfig.inputImageHeight,
        (y) => List.generate(ModelConfig.inputImageWidth, (x) {
          final pixel = resized.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    );

    return input;
  }

  static Uint8List normalizeImage(img.Image image) {
    final pixels = <double>[];

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        pixels.add(pixel.r / 255.0);
        pixels.add(pixel.g / 255.0);
        pixels.add(pixel.b / 255.0);
      }
    }

    final buffer = Float32List.fromList(pixels);
    return buffer.buffer.asUint8List();
  }

  static img.Image? decodeImage(Uint8List bytes) {
    return img.decodeImage(bytes);
  }

  static Future<bool> validateImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return false;
      }

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      return image != null;
    } catch (e) {
      return false;
    }
  }
}
