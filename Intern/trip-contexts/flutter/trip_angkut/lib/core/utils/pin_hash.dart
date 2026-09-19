import 'dart:convert';
import 'package:crypto/crypto.dart';

class PinHash {
  // Hash PIN dengan SHA-256
  static String hash(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Validasi PIN format
  static bool isValidFormat(String pin) {
    return pin.length == 6 && RegExp(r'^\d{6}$').hasMatch(pin);
  }

  // Mask PIN untuk ditampilkan
  static String maskPin(String pin) {
    if (pin.length != 6) return pin;
    return '${pin.substring(0, 2)}****${pin.substring(4)}';
  }
}