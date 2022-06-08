import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:medsi/models/storage_utils.dart';

class Settings with ChangeNotifier {
  int administrationListIntervalMinutes = 5;
  int medicationListProcessIntervalMinutes = 5;
  int logonProcessIntervalMinutes = 60;

  Settings(
      {required this.administrationListIntervalMinutes,
      required this.medicationListProcessIntervalMinutes,
      required this.logonProcessIntervalMinutes});

  Future<void> getSystemIntervalsInstance() async {
    dynamic systemIntervals = await medsiStorage.read(key: "System_Intervals");
    dynamic systemIntervalsConv = json.decode(systemIntervals);

    this.administrationListIntervalMinutes =
        systemIntervalsConv["administrationListIntervalMinutes"] as int;
    this.medicationListProcessIntervalMinutes =
        systemIntervalsConv["medicationListProcessIntervalMinutes"] as int;
    this.logonProcessIntervalMinutes =
        systemIntervalsConv["logonProcessIntervalMinutes"] as int;
  }

  static Future<Settings> getSystemIntervals() async {
    dynamic systemIntervals = await medsiStorage.read(key: "System_Intervals");
    dynamic systemIntervalsConv = json.decode(systemIntervals);
    Settings settingObj = Settings(
        administrationListIntervalMinutes:
            systemIntervalsConv["administrationListIntervalMinutes"] as int,
        medicationListProcessIntervalMinutes:
            systemIntervalsConv["medicationListProcessIntervalMinutes"] as int,
        logonProcessIntervalMinutes:
            systemIntervalsConv["logonProcessIntervalMinutes"] as int);
    return settingObj;
  }

  static Future<void> setSystemIntervals(Settings currentSettingObj,
      int admInterval, int medInterval, int logonInterval) async {
    currentSettingObj.administrationListIntervalMinutes = admInterval;
    currentSettingObj.medicationListProcessIntervalMinutes = medInterval;
    currentSettingObj.logonProcessIntervalMinutes = logonInterval;
    currentSettingObj.notifyListeners();
    medsiStorage.write(
        key: "System_Intervals",
        value:
            "{\"administrationListIntervalMinutes\":${currentSettingObj.administrationListIntervalMinutes}, \"medicationListProcessIntervalMinutes\":${currentSettingObj.medicationListProcessIntervalMinutes}, \"logonProcessIntervalMinutes\":${currentSettingObj.logonProcessIntervalMinutes}}");
  }
}
