import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medsi/views/logon_view.dart';
import 'package:medsi/provider_utils/auth_provider.dart';
import 'package:medsi/provider_utils/frequency_provider.dart';
import 'package:medsi/provider_utils/medslist_provider.dart';
import 'package:medsi/provider_utils/facilities_provider.dart';
import 'package:medsi/models/storage_utils.dart';
import 'package:medsi/tasks/background_handle.dart';
import 'package:medsi/views/medication_list_view.dart';
import 'package:medsi/views/facilities_view.dart';
import 'package:medsi/widgets/facility_detail.dart';
import 'package:medsi/models/facility_model.dart';

MedicationList MedicationListObj = MedicationList();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    runInitialStorage();

    //provider refresh timers
    Timer.periodic(const Duration(seconds: 5), (Timer anonymus) {
      MedicationListObj.getMedList();
    });
    //

    FrequencyProvider FrequencyProviderObj = FrequencyProvider();
    FrequencyProviderObj.readFreqListIntoFreqObj();

    Map<String, Widget Function(BuildContext)> medsiRoutes = {
      MedicationListView.routeName: (context) => MedicationListView(),
      MedsiLogonView.routeName: (context) => MedsiLogonView(),
      FacilitiesView.routeName: (context) => FacilitiesView(),
      FacilityDetail.routeName: (context) => FacilityDetail(),
    };

    Auth AuthObj = Auth();
    FacilitiesProvider FacilitiesObj = FacilitiesProvider();
    FacilitiesObj.getFacilites();

    MultiProvider retVal = MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthObj,
        ),
        ChangeNotifierProvider.value(
          value: MedicationListObj,
        ),
        ChangeNotifierProvider.value(value: FrequencyProviderObj),
        ChangeNotifierProvider.value(value: FacilitiesObj),
      ],
      child: MaterialApp(
        title: 'Medsi',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MedsiLogonView(),
        routes: medsiRoutes,
      ),
    );

    //background work handler

    BackGroundServiceMgr.runFromMain();
    //end of background work handler

    return retVal;
  }
}
