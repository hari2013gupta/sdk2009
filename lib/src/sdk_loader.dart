import 'package:flutter/material.dart';
import 'package:sdk2009/src/sdk_app.dart';
import 'package:sdk2009/src/singleton/connection_util.dart';
import 'package:sdk2009/src/utils/app_validation.dart';
import 'package:sdk2009/src/utils/tuple.dart';

class SdkLoader extends StatelessWidget {
  final String url;

  const SdkLoader({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      Tuple validationResult = AppValidation().isValidUrl(url);
      if (!validationResult.x && context.mounted) {
        Navigator.of(context).pop();
        return;
      }
      ConnectionUtil con = ConnectionUtil.getInstance();
      final connected = await con.checkInternetConnection();
      if (!context.mounted) {
        return;
      }
      if (!connected) {
        Navigator.of(context).pop();
        return;
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SdkApp(url: url),
      ));
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
