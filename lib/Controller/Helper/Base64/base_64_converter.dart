import 'dart:convert';
import 'dart:io';

class Base64ConverterCustom{
  Base64ConverterCustom._privateConstructor();
  static final Base64ConverterCustom instance = Base64ConverterCustom._privateConstructor();

  static Future<String?> fileToBase64({required String filePath}) async {
    final file = File(filePath);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    }
    return null;
  }
}
