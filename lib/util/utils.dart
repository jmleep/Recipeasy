import 'dart:io';

class Utils {
  static T cast<T>(x) => x is T ? x : null;

  static Future<File> loadFileFromPath(String filename) async {
    File f = new File(filename);
    return f;
  }
}
