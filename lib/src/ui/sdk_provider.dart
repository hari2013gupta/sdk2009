import 'package:flutter/material.dart';
import 'package:sdk2009/src/ui/sdk_inherited_widget.dart';

class SdkProvider extends StatefulWidget {
  final Widget child;
  const SdkProvider({super.key, required this.child});

  @override
  State<SdkProvider> createState() => _SdkProviderState();
}

class _SdkProviderState extends State<SdkProvider> {
  bool _isLoading = false;
  void _loadingStarted() {
    setState(() {
      _isLoading = true;
    });
  }
  void _loadingCompleted() {
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    _loadingStarted();
    return SdkInheritedWidget(isLoading: _isLoading, loadingCompleted: _loadingCompleted,
    child: widget.child);
  }
}
