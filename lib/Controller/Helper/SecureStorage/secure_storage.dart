import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageCustom{
  SecureStorageCustom._privateConstructor();
  static final SecureStorageCustom instance = SecureStorageCustom._privateConstructor();

  static FlutterSecureStorage secureStorage = const FlutterSecureStorage();


  static Future<void> getInstance()async{
    if(Platform.isAndroid) {
      AndroidOptions getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true,);
      secureStorage = FlutterSecureStorage(aOptions: getAndroidOptions());
    }


  }




  static Future<void> save({required String key,required String value})async{
    await getInstance();
    await secureStorage.write(key: key, value: value);
  }

  static Future<String> getValue({required String key})async{
    await getInstance();
    return await secureStorage.read(key: key) ?? "";
  }

}