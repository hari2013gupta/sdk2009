import 'package:flutter/material.dart';
const upiLink1 =
    'phonepe://upi/pay?pa=112233220@ibl&pn=phonepetest&tid=67890&tr=txn123&tn=payment&am=5000&cu=INR&url';
const upiLink2 =
    'gpay://upi/pay?pa=112233220@ibl&pn=gpaytest&tid=67890&tr=txn123&tn=payment&am=5000&cu=INR&url';
const upiLink3 =
    'sbipay://upi/pay?pa=112233220@ibl&pn=testLink&tid=67890&tr=txn123&tn=payment&am=5000&cu=INR&url';
const defaultUpiLink = 'upi://pay?pa=112233220@ibl&am=10&pn=harry&tn=testing&cu=INR';
// test package names
const defaultUpiPackage = 'com.whatsapp'; // to handle error
const amazonPackage = 'in.amazon.mShop.android.shopping';
const payTmPackage = 'net.one97.paytm';
const phonePePackage = 'com.phonepe.app';
const googlePackage = 'com.google.android.apps.nbu.paisa.user';
// test urls
const googleUrl = 'https://google.com/';
const sbiCardUrl = 'https://sbicard.com/';

void showInternetDialog({
  required BuildContext context,
  String? applicationName,
  String? applicationVersion,
  Widget? applicationIcon,
  String? applicationLegalese,
  List<Widget>? children,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return AboutDialog(
        applicationName: applicationName,
        applicationVersion: applicationVersion,
        applicationIcon: applicationIcon,
        applicationLegalese: applicationLegalese,
        children: children,
      );
    },
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
/// Displays a [LicensePage], which shows licenses for software used by the
/// application.
///
/// The application arguments correspond to the properties on [LicensePage].
///
/// The `context` argument is used to look up the [Navigator] for the page.
///
/// The `useRootNavigator` argument is used to determine whether to push the
/// page to the [Navigator] furthest from or nearest to the given `context`. It
/// is `false` by default.
///
/// If the application has a [Drawer], consider using [AboutListTile] instead
/// of calling this directly.
///
/// The [AboutDialog] shown by [showAboutDialog] includes a button that calls
/// [showLicensePage].
///
/// The licenses shown on the [LicensePage] are those returned by the
/// [LicenseRegistry] API, which can be used to add more licenses to the list.
}
