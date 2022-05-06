import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:medsi/logger/logger.dart';
import 'package:medsi/models/facility_model.dart';
import 'package:medsi/views/medication_list_view.dart';
import 'package:medsi/widgets/common_widgets.dart';
import 'package:medsi/views/logon_view.dart';
import 'package:medsi/widgets/facilities_list.dart';
import 'package:medsi/widgets/error_widget.dart';
import 'package:medsi/widgets/facility_detail.dart';

class FacilitiesView extends StatelessWidget {
  static const routeName = "Facilities";

  @override
  Widget build(BuildContext context) {
    try {
      Widget FacilitiesList = Scaffold(
          appBar: MedsiAppBar, body: const Text("UnSupported Platform!"));

      if (Platform.isAndroid) {
        FacilitiesList = Scaffold(
          appBar: AppBar(
            title: const Text("Medsi"),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(MedicationListView.routeName);
                  },
                  icon: const Icon(Icons.medication)),
              IconButton(
                  onPressed: (() => Navigator.of(context)
                      .pushReplacementNamed(MedsiLogonView.routeName)),
                  icon: const Icon(Icons.logout)),
            ],
          ),
          body: const FacilitiesListAndroid(),
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: (() => Navigator.of(context).pushNamed(
                  FacilityDetail.routeName,
                  arguments: Facility("", "", "", "", "")))),
        );
      } else if (Platform.isIOS) {
        FacilitiesList = CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                middle: const Text('Medsi'),
                trailing: IconButton(
                    onPressed: (() => Navigator.of(context)
                        .pushReplacementNamed(MedsiLogonView.routeName)),
                    icon: const Icon(CupertinoIcons.arrow_left_circle))),
            child: FacilitiesListAndroid());
      }

      return FacilitiesList;
    } catch (eError) {
      Logger.logMe("FacilitiesView.error", eError.toString());
      return MedsiErrorWidget(
          MessageOfError:
              "Error During Login click this button to upload the log to support!");
    }
  }
}
