import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class Utils {
  static T cast<T>(x) => x is T ? x : null;

  static Future<Image> loadPrimaryImage(Uint8List image) async {
    return Image.memory(image);
  }
}
