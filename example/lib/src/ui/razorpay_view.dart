import 'package:flutter/material.dart';
import 'package:sdk2009_example/src/ui/razorpay/razorpay_integration.dart';

class RazorpayView extends StatefulWidget {
  const RazorpayView({super.key});

  @override
  State<RazorpayView> createState() => _RazorpayViewState();
}

class _RazorpayViewState extends State<RazorpayView> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
      child: TextButton(
          onPressed: () {
            // create an instance of razorPayIntegration
            final RazorPayIntegration integration = RazorPayIntegration();
            integration.openSession(amount: 10);
          },
          child: const Text('Razor Pay', style: TextStyle(fontSize: 18))),
    ));
  }
}
