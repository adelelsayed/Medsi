import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:medsi/views/facilities_view.dart';
import 'package:medsi/widgets/system_settings_widget.dart';
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

      MedsiList = Scaffold(
          appBar: AppBar(
            title: Text("Medsi"),
            actions: [
              IconButton(
                  onPressed: (() => Navigator.of(context)
                      .pushReplacementNamed(SystemSettingsWidget.routeName)),
                  icon: const Icon(Icons.settings)),
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

      return MedsiList;
    } catch (eError) {
      Logger.logMe("MedicationListView.error", eError.toString());
      return MedsiErrorWidget(
          MessageOfError:
              "Error During Login click this button to upload the log to support!");
    }
  }
}
