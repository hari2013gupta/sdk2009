import 'package:flutter/foundation.dart';

@immutable
class UpiMeta {
  const UpiMeta({
    required this.data,
  });

  final List<UpiObject> data;

  factory UpiMeta.fromJson(json) => UpiMeta(
      data: (json['data'] as List? ?? [])
          .map((e) => UpiObject.fromJson(e as Map<String, dynamic>))
          .toList());

  Map<String, dynamic> toJson() =>
      {'data': data.map((e) => e.toJson()).toList()};

  UpiMeta clone() => UpiMeta(data: data.map((e) => e.clone()).toList());

  UpiMeta copyWith({List<UpiObject>? data}) => UpiMeta(
        data: data ?? this.data,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UpiMeta && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

@immutable
class UpiObject {
  const UpiObject({
    required this.name,
    required this.packageName,
    required this.icon,
  });

  final String name;
  final String packageName;
  final String icon;

  factory UpiObject.fromJson(Map<String, dynamic> json) => UpiObject(
      name: json['name'].toString(),
      packageName: json['package_name'].toString(),
      icon: json['icon'].toString());

  Map<String, dynamic> toJson() =>
      {'name': name, 'package_name': packageName, 'icon': icon};

  UpiObject clone() =>
      UpiObject(name: name, packageName: packageName, icon: icon);

  UpiObject copyWith({String? name, String? packageName, String? icon}) =>
      UpiObject(
        name: name ?? this.name,
        packageName: packageName ?? this.packageName,
        icon: icon ?? this.icon,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpiObject &&
          name == other.name &&
          packageName == other.packageName &&
          icon == other.icon;

  @override
  int get hashCode => name.hashCode ^ packageName.hashCode ^ icon.hashCode;
}
