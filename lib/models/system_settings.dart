import 'dart:convert';
import 'package:medsi/models/storage_utils.dart';

class Settings {
  int administrationListIntervalMinutes = 5;
  int medicationListProcessIntervalMinutes = 5;
  int logonProcessIntervalMinutes = 60;

  Settings(
      {required this.administrationListIntervalMinutes,
      required this.medicationListProcessIntervalMinutes,
      required this.logonProcessIntervalMinutes});

  static Future<Settings> getSystemIntervals() async {
    dynamic systemIntervals = await medsiStorage.read(key: "System_Intervals");
    dynamic systemIntervalsConv = json.decode(systemIntervals);
    Settings SettingObj = Settings(
        administrationListIntervalMinutes:
            systemIntervalsConv["administrationListIntervalMinutes"] as int,
        medicationListProcessIntervalMinutes:
            systemIntervalsConv["medicationListProcessIntervalMinutes"] as int,
        logonProcessIntervalMinutes:
            systemIntervalsConv["logonProcessIntervalMinutes"] as int);
    return SettingObj;
  }

  static Future<void> setSystemIntervals(
      int admInterval, int medInterval, int logonInterval) async {
    Settings SettingObj = Settings(
        administrationListIntervalMinutes: admInterval,
        medicationListProcessIntervalMinutes: medInterval,
        logonProcessIntervalMinutes: logonInterval);
    medsiStorage.write(
        key: "System_Intervals",
        value:
            "{\"administrationListIntervalMinutes\":${SettingObj.administrationListIntervalMinutes}, \"medicationListProcessIntervalMinutes\":${SettingObj.medicationListProcessIntervalMinutes}, \"logonProcessIntervalMinutes\":${SettingObj.logonProcessIntervalMinutes}}");
  }
}
