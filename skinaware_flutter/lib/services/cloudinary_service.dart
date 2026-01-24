import 'dart:io';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';

/// Service for uploading images to Cloudinary
class CloudinaryService {
  late final Cloudinary _cloudinary;

  CloudinaryService() {
    _cloudinary = Cloudinary.full(
      apiKey: '139416567825137',
      apiSecret: '1Wyibr3kDzQKisKMLUNxtUqFOIs',
      cloudName: 'dbctarglm',
    );
  }

  /// Upload image to Cloudinary and return the URL
  Future<String> uploadImage(String imagePath) async {
    try {
      final response = await _cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: imagePath,
          fileBytes: await File(imagePath).readAsBytes(),
          resourceType: CloudinaryResourceType.image,
          folder: 'skinaware',
          fileName: 'skin_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );

      if (response.isSuccessful && response.secureUrl != null) {
        return response.secureUrl!;
      } else {
        throw Exception('Failed to upload image: ${response.error}');
      }
    } catch (e) {
      throw Exception('Cloudinary upload error: $e');
    }
  }

  /// Upload multiple images and return list of URLs
  Future<List<String>> uploadMultipleImages(List<String> imagePaths) async {
    final urls = <String>[];

    for (final path in imagePaths) {
      final url = await uploadImage(path);
      urls.add(url);
    }

    return urls;
  }

  /// Delete image from Cloudinary by public ID
  Future<bool> deleteImage(String publicId) async {
    try {
      final response = await _cloudinary.deleteResource(
        url: publicId,
        resourceType: CloudinaryResourceType.image,
        invalidate: false,
      );

      return response.isSuccessful;
    } catch (e) {
      print('Failed to delete image: $e');
      return false;
    }
  }
}
