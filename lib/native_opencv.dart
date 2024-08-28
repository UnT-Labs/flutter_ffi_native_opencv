
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:native_opencv/generated_bindings.dart';

import 'native_opencv_platform_interface.dart';

class NativeOpencv {
  Future<String?> getPlatformVersion() {
    return NativeOpencvPlatform.instance.getPlatformVersion();
  }

  GeneratedBindings? bindings;
  NativeOpencv() {
    bindings = GeneratedBindings(_openDynamicLibrary());
  }
  String? opencvVersion() {
    return 
      bindings?.opencvVersion().cast<Utf8>().toDartString();
  }
      

// Getting a library that holds needed symbols
  DynamicLibrary _openDynamicLibrary() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libnative_opencv.so');
    }
    return DynamicLibrary.process();
  }
}
