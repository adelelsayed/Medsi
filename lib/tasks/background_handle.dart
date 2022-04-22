/*
import 'package:workmanager/workmanager.dart';

void mainWorkMgrCall(List<Map<String, Object>> medsiTasks) {
  medsiTasks.forEach((Tsk) {
    Workmanager().initialize(
      Tsk["Function"]
          as Function, // The top level function, aka callbackDispatcher
      //isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    );

    Workmanager().registerPeriodicTask(
      Tsk["id"].toString() as String,
      Tsk["name"] as String,
      frequency: Tsk["DurationObj"] as Duration,
    );
  });
}
*/

import 'dart:developer';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:medsi/tasks/medication_list_fetch_process.dart';
import 'package:medsi/models/storage_utils.dart';
import 'package:medsi/logger/logger.dart';
import 'package:medsi/tasks/dose_notification_process.dart';

class BackGroundServiceMgr {
  //list to run is formatted as [{"myfunc":{interval_in_seconds_to_run_it: [Future<void> myfunc, void my_then_func]}},{},..] where myfunc and my_then_func are a future void function
  List<Map<String, Map<int, List<Future<void> Function()>>>> listToRun = [];
  String generatedCode = "";

  static void runFromMain() {
    WidgetsFlutterBinding.ensureInitialized();

    Logger.logMe(
        "BackGroundServiceMgr.runFromMain", "Started BackGroundServiceMgr");

    BackGroundServiceMgr BackServ = BackGroundServiceMgr();
    BackServ.runBackService();

    Logger.logMe(
        "BackGroundServiceMgr.runFromMain", "Finished BackGroundServiceMgr");
  }

  Future<void> runBackService() async {
    var channel = const MethodChannel('com.example.medsi/background_service');

    CallbackHandle callbackHandle =
        PluginUtilities.getCallbackHandle(operatorForIsolates)
            as CallbackHandle;

    await channel.invokeMethod('startService', callbackHandle.toRawHandle());
  }
}

void operatorForIsolates() {
  WidgetsFlutterBinding.ensureInitialized();

  int medInterval = 0;
  int admInterval = 0;
  MedicationListProcess.getintervalMinutes().then((value) {
    medInterval = value;

    AdministrationListProcess.getintervalMinutes().then((value) {
      admInterval = value;

      List<Map<String, Map<int, List<Future<void> Function()>>>> listToRun = [
        {
          "medication_list_fetch_process": {
            medInterval * 60: [MedicationListProcess.getMedsListOnce]
          }
        },
        {
          "getNotification": {
            admInterval * 60: [AdministrationListProcess.getNotification]
          }
        }
      ];

      for (var taskMap in listToRun) {
        Map<String, Map<int, List<Future<void> Function()>>> currentTaskMap =
            taskMap;
        String currentTaskName = currentTaskMap.keys.first;
        int currentIntervalSeconds = currentTaskMap.values.first.keys.first;
        Future<void> Function() currentPrimaryFunction =
            currentTaskMap.values.first.values.first[0];

        Timer.periodic(Duration(seconds: currentIntervalSeconds),
            (Timer anonymus) {
          currentPrimaryFunction();
        });
      }
    });
  });
}
