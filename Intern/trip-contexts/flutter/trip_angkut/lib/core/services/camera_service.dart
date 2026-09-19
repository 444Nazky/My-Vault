import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../constants/app_constants.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  // Ambil foto dari kamera
  Future<PhotoResult> takePhoto({
    ImageSource source = ImageSource.camera,
    String? prefix,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: AppConstants.imageMaxWidth.toDouble(),
        maxHeight: AppConstants.imageMaxHeight.toDouble(),
        imageQuality: AppConstants.imageQuality,
      );

      if (pickedFile == null) {
        return PhotoResult(
          success: false,
          error: 'Tidak ada foto yang dipilih',
        );
      }

      // Simpan foto ke direktori lokal
      final savedPath = await _savePhoto(
        pickedFile.path,
        prefix: prefix,
      );

      return PhotoResult(
        success: true,
        path: savedPath,
        fileName: path.basename(savedPath),
      );
    } catch (e) {
      return PhotoResult(
        success: false,
        error: 'Gagal mengambil foto: $e',
      );
    }
  }

  // Ambil foto selfie kendaraan
  Future<PhotoResult> takeVehicleSelfie() async {
    return await takePhoto(
      source: ImageSource.camera,
      prefix: 'vehicle_selfie',
    );
  }

  // Ambil foto kondisi kosong
  Future<PhotoResult> takeEmptyConditionPhoto() async {
    return await takePhoto(
      source: ImageSource.camera,
      prefix: 'empty_condition',
    );
  }

  // Simpan foto ke direktori lokal
  Future<String> _savePhoto(String tempPath, {String? prefix}) async {
    final appDir = await getApplicationDocumentsDirectory();
    final photoDir = Directory('${appDir.path}/photos');

    if (!await photoDir.exists()) {
      await photoDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(tempPath);
    final fileName = '${prefix ?? 'photo'}_$timestamp$extension';
    final savedPath = '${photoDir.path}/$fileName';

    final file = File(tempPath);
    await file.copy(savedPath);

    return savedPath;
  }

  // Hapus foto
  Future<bool> deletePhoto(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting photo: $e');
      return false;
    }
  }

  // Kompres foto untuk upload
  Future<String> compressPhoto(String filePath) async {
    // Note: Implementasi kompresi lebih lanjut bisa menggunakan package flutter_image_compress
    // Untuk sekarang, return path asli
    return filePath;
  }

  // Validasi foto
  PhotoValidation validatePhoto(String? filePath) {
    if (filePath == null || filePath.isEmpty) {
      return PhotoValidation(
        isValid: false,
        message: 'Foto belum diambil',
      );
    }

    final file = File(filePath);
    if (!file.existsSync()) {
      return PhotoValidation(
        isValid: false,
        message: 'File foto tidak ditemukan',
      );
    }

    // Cek ukuran file (max 5MB)
    final fileSize = file.lengthSync();
    if (fileSize > 5 * 1024 * 1024) {
      return PhotoValidation(
        isValid: false,
        message: 'Ukuran foto terlalu besar (maksimal 5MB)',
      );
    }

    return PhotoValidation(
      isValid: true,
      message: 'Foto valid',
      fileSize: fileSize,
    );
  }
}

class PhotoResult {
  final bool success;
  final String? path;
  final String? fileName;
  final String? error;

  PhotoResult({
    required this.success,
    this.path,
    this.fileName,
    this.error,
  });
}

class PhotoValidation {
  final bool isValid;
  final String message;
  final int? fileSize;

  PhotoValidation({
    required this.isValid,
    required this.message,
    this.fileSize,
  });
}