import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/users.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/src/main/kotlin/com.sdk2009.sdk2009/pigeon/Users.g.kt',
  kotlinOptions: KotlinOptions(),
  javaOut: 'android/src/main/java/io/flutter/plugins/Users.java',
  javaOptions: JavaOptions(),
  swiftOut: 'ios/Runner/Users.g.swift',
  swiftOptions: SwiftOptions(),
  objcHeaderOut: 'macos/Runner/users.g.h',
  objcSourceOut: 'macos/Runner/users.g.m',
  // Set this to a unique prefix for your plugin or application, per Objective-C naming conventions.
  objcOptions: ObjcOptions(prefix: 'PGN'),
  copyrightHeader: 'pigeons/copyright.txt',
  dartPackageName: 'pigeon_package',
))
class User {
  final String name;
  final int mobileNo;

  User({required this.name, required this.mobileNo});
}

@HostApi()
abstract class UserHostApi {
  String getHostLanguage();

  @async
  bool saveUser(User user);

  @async
  User getUser();

  @async
  List<User> getAllUser();
}

// Define the data class.
class Message {
  final String content;

  Message({required this.content});
}

// Define the host API with methods for native communication.
@HostApi()
abstract class MessageHostApi {
  void sendMessage(Message message);
}
