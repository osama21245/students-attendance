import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:upgrader/upgrader.dart';

import '../../const/constants.dart';
import '../../utils/open_url.dart';

class CustomUpgrader extends StatelessWidget {
  final Widget widget;
  CustomUpgrader({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      dialogStyle: Platform.isAndroid
          ? UpgradeDialogStyle.material
          : UpgradeDialogStyle.cupertino,
      upgrader: Upgrader(
        debugLogging: false,
        debugDisplayAlways: false,
        languageCode: "ar",
        messages: UpgraderMessages(code: "ar"),
        countryCode: "EG",
        minAppVersion: "1.0.0",
      ),
      onUpdate: () {
        if (Platform.isAndroid) {
          openUrl(Constants.googleStoreLink);
        } else {
          openUrl(Constants.appStoreLink);
        }
        return true; // Ensure to return a boolean value
      },
      child: widget,
    );
  }
}
