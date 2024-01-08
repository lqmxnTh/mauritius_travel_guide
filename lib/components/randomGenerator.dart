// ignore_for_file: file_names

import 'dart:math' show Random;

String generateRandomString(int length) {
  final random = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const charLength = chars.length;

  String result = '';

  for (int i = 0; i < length; i++) {
    final randomIndex = random.nextInt(charLength);
    result += chars[randomIndex];
  }

  return result;
}
