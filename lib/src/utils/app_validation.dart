/// This class is responsible for handling all the checks related to the
/// network arability before proceeding with payment URL.
///
/// This class does all the validation related to network check and for the payment
/// URL before proceeding and makes sure it’s validated as per the configuration.
library;

import 'dart:developer';

import 'package:sdk2009/src/utils/tuple.dart';

class AppValidation {
  final urlPatternA =
      r"(https)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
  String urlPatternB =
      r'^((?:.|\n)*?)((https:\/\/www\.|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
  final urlPatternC =
      r'(https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';

  /// This method is used to validate a [url]
  ///
  Tuple isValidUrl(String url) {
    bool isValid = true;
    String message = '';

    try {
      if (url.isEmpty) {
        throw Exception('Url should not be empty');
      }
      if (!url.startsWith('https://')) {
        throw Exception('Payment url should start with https://');
      }

      final Uri? uri = Uri.tryParse(url);
      if (uri == null || !uri.hasAbsolutePath) {
        throw Exception('Please enter valid url');
      }
      try {
        final uri = Uri.parse(url);
        // Check if the URL scheme is HTTPS and that the URI has a host
        // return uri.scheme == 'https' && uri.host.isNotEmpty;
        if (uri.scheme != 'https') {
          throw Exception('Not a secure url');
        }
        if (uri.host.isEmpty) {
          throw Exception('Empty host');
        }
        if (!uri.isAbsolute) {
          throw Exception('Invalid payment url');
        }
      } on Exception catch (e) {
        // If parsing fails, it's not a valid URL
        throw Exception('Parse Error: $e');
      }
      // final matches = RegExp(urlPatternA, caseSensitive: false).firstMatch(url);
      final match = RegExp(urlPatternA, caseSensitive: false);
      if (!match.hasMatch(url)) {
        throw Exception('Not valid');
      }
      // RegExp regExp = RegExp(urlPatternA);
      // if (!regExp.hasMatch(url)) {
      //   throw Exception('Validation failed');
      // }

      // if (!url.contains('id')) {
      //   throw Exception('Payment url should have valid id');
      // }
    } on Exception catch (e) {
      message = 'Err: $e';
      isValid = false;
    }
    log('Validation : $message');
    // Tuple<bool, String> tuple = Tuple(isValid, message);
    return Tuple(isValid, message);
  }

  /// Description:
  /// hexRegex: This regular expression (^[a-fA-F0-9]+$) checks if the string contains only valid hexadecimal characters.
  /// Length Check: Depending on the hashing algorithm, you validate that the length matches:
  /// MD5: 32 characters (128 bits).
  /// SHA-1: 40 characters (160 bits).
  /// SHA-256: 64 characters (256 bits).
  /// uses of function
  /// isValidHashKey(md5Hash, 'MD5'));       // true
  /// isValidHashKey(sha256Hash, 'SHA-256')); // true
  /// isValidHashKey("12345", 'SHA-256'));    // false
  bool isValidHashKey(String hashKey, String algorithm) {
    // Regular expression to match a valid hex string
    final hexRegex = RegExp(r'^[a-fA-F0-9]+$');

    // Check if the string is a valid hex string
    if (!hexRegex.hasMatch(hashKey)) {
      return false;
    }

    // Validate based on the length for different hash algorithms
    switch (algorithm) {
      case 'MD5':
        return hashKey.length == 32; // MD5 is 128 bits = 32 hex characters
      case 'SHA-1':
        return hashKey.length == 40; // SHA-1 is 160 bits = 40 hex characters
      case 'SHA-256':
        return hashKey.length == 64; // SHA-256 is 256 bits = 64 hex characters
      default:
        return false; // Unsupported algorithm
    }
  }

  /// This method is used to check internet connectivity
  ///
  isNetworkAvailable() {}
}
