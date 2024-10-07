import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadIndexHtml() async {
  return await rootBundle.loadString('assets/www/index.html');
}