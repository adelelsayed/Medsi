import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medsi/views/facilities_view.dart';
import 'dart:io';

import 'package:medsi/widgets/medication_list_widget.dart';
import 'package:medsi/widgets/common_widgets.dart';
import 'package:medsi/widgets/error_widget.dart';
import 'package:medsi/logger/logger.dart';
import 'package:medsi/views/logon_view.dart';

class MedicationListView extends StatelessWidget {
  static String routeName = "MedicationList";

  @override
  Widget build(BuildContext context) {
    try {
      Widget MedsiList = Scaffold(
          appBar: MedsiAppBar, body: const Text("UnSupported Platform!"));

      if (Platform.isAndroid) {
        MedsiList = Scaffold(
            appBar: AppBar(
              title: Text("Medsi"),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(FacilitiesView.routeName);
                    },
                    icon: const Icon(Icons.local_hospital)),
                IconButton(
                    onPressed: (() => Navigator.of(context)
                        .pushReplacementNamed(MedsiLogonView.routeName)),
                    icon: const Icon(Icons.logout))
              ],
            ),
            body: MedicationListAndroid());
      } else if (Platform.isIOS) {
        MedsiList = CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                middle: const Text('Medsi'),
                trailing: IconButton(
                    onPressed: (() => Navigator.of(context)
                        .pushReplacementNamed(MedsiLogonView.routeName)),
                    icon: const Icon(CupertinoIcons.arrow_left_circle))),
            child: MedicationListIOS());
      }

      return MedsiList;
    } catch (eError) {
      Logger.logMe("MedicationListView.error", eError.toString());
      return MedsiErrorWidget(
          MessageOfError:
              "Error During Login click this button to upload the log to support!");
    }
  }
}
