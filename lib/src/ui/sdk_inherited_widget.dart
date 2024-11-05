import 'package:flutter/material.dart';

class SdkInheritedWidget extends InheritedWidget {
  final bool isLoading;
  final Function loadingCompleted;

  const SdkInheritedWidget(
      {super.key, required super.child, required this.isLoading, required this.loadingCompleted});

  // This method lets descendant widgets find the nearest SdkController
  static SdkInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SdkInheritedWidget>();
  }

  // This determines when to rebuild widgets that depend on this SdkController
  @override
  bool updateShouldNotify(SdkInheritedWidget oldWidget) {
    return isLoading != oldWidget.isLoading;
  }
}
