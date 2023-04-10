import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScannerCustom {
  ScannerCustom._privateConstructor();
  static final ScannerCustom instance = ScannerCustom._privateConstructor();

  /// Qr Code
  static Future<String?> getQrCode() async {
    return await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);
  }

  /// Bar Code
  static Future<String?> getBarCode() async {
    return await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.BARCODE);
  }

}