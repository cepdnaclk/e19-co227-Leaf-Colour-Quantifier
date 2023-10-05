import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ServerConnection {
  static final ServerConnection _singleton = ServerConnection._internal();
  static const String _baseUrl = 'http://192.168.0.100:5000';

  factory ServerConnection() {
    return _singleton;
  }

  ServerConnection._internal();

  Future<File> sendImageAndGetProcessedImage(File imageFile) async {
    var url = Uri.parse('$_baseUrl/image/segmentaion');
    var request = http.MultipartRequest('POST', url);
    var file = await http.MultipartFile.fromPath('file', imageFile.path);
    request.files.add(file);
    var response = await request.send();
    var processedImage = await http.Response.fromStream(response);

    var tempDir = await getTemporaryDirectory();
    var tempPath = tempDir.path;
    var processedImageFilePath = '$tempPath/processed_image.jpg';

    // Delete the old file if it exists
    var oldFile = File(processedImageFilePath);
    if (await oldFile.exists()) {
      await oldFile.delete();
    }

    // Create and return the new file
    var processedImageFile = await File(processedImageFilePath).writeAsBytes(processedImage.bodyBytes);
    return processedImageFile;
  }

  Future<File> sendImageAndMaskAndGetProcessedImage(File imageFile, Uint8List maskBytes) async {
    var url = Uri.parse('$_baseUrl/image/segmentaion/mask');
    var request = http.MultipartRequest('POST', url);

    var image = await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(image);

    var mask = http.MultipartFile.fromBytes(
        'mask', maskBytes, filename: 'mask.png');
    request.files.add(mask);

    var response = await request.send();
    var processedImage = await http.Response.fromStream(response);

    var tempDir = await getTemporaryDirectory();
    var tempPath = tempDir.path;
    var processedImageFilePath = '$tempPath/processed_image.jpg';

    // Delete the old file if it exists
    var oldFile = File(processedImageFilePath);
    if (await oldFile.exists()) {
      await oldFile.delete();
    }

    // Create and return the new file
    var processedImageFile = await File(processedImageFilePath).writeAsBytes(
        processedImage.bodyBytes);

    return processedImageFile;
  }
}
