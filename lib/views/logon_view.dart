import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:medsi/widgets/android_logon_widgets.dart';
import 'package:medsi/widgets/ios_logon_widgets.dart';
import 'package:medsi/widgets/common_widgets.dart';
import 'package:medsi/logger/logger.dart';
import 'package:medsi/widgets/error_widget.dart';

class MedsiLogonView extends StatelessWidget {
  static String routeName = "Login";

  @override
  Widget build(BuildContext context) {
    try {
      Widget LogonWidget = Scaffold(
          appBar: MedsiAppBar, body: const Text("UnSupported Platform!"));

      if (Platform.isAndroid) {
        LogonWidget = Scaffold(appBar: MedsiAppBar, body: LogonAndroid());
      } else if (Platform.isIOS) {
        LogonWidget = CupertinoPageScaffold(
            navigationBar: MedsiAppBarIOS, child: LogonIOS());
      }

      return LogonWidget;
    } catch (eError) {
      Logger.logMe("MedsiLogonView.error", eError.toString());
      return MedsiErrorWidget(
          MessageOfError:
              "Error During Login click this button to upload the log to support!");
    }
  }
}
