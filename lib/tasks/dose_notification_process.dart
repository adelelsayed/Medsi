import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:medsi/models/notification_model.dart';
import 'package:medsi/utils/notification_pipe.dart';
import 'package:medsi/models/storage_utils.dart';
import 'package:medsi/provider_utils/medslist_provider.dart';
import 'package:medsi/provider_utils/frequency_provider.dart';
import 'package:medsi/models/frequency.dart';

class AdministrationListProcess {
  List<Map<String, DateTime>> currentAdministrationList = [];

  static Future<int> getintervalMinutes() async {
    int retVal = 0;
    await medsiStorage
        .read(key: "AdministrationList_intervalMinutes")
        .then((value) {
      retVal = value != null ? int.parse(value) : 5;
    });
    return retVal;
  }

  static Future<void> getNotification() async {
    WidgetsFlutterBinding.ensureInitialized();

    MedsiNotificationChannel thisNotificationChannel = MedsiNotificationChannel(
        id: "MedsiNotificationChannel", name: "MedsiNotificationChannel");

    AdministrationListProcess currentAdministrationListProcess =
        AdministrationListProcess();

    currentAdministrationListProcess.getNextIntervalAdministrations();

    await establishNotificationSettings().then((value) {
      for (var item
          in currentAdministrationListProcess.currentAdministrationList) {
        pushMedsiNotification(
            MedsiNotification(
                id: DateTime.now().millisecond,
                title: item.keys.first,
                subject: item.values.first.toString()),
            thisNotificationChannel);
      }
    });
  }

  getNextIntervalAdministrations() {
    final FrequencyProvider FrequencyObjList = FrequencyProvider();
    FrequencyObjList.readFreqListIntoFreqObj(notify_listeners: false);

    MedicationList currentMedicationList = MedicationList();
    currentMedicationList.getMedList(notify_listeners: false).then((value) {
      for (var medItem in currentMedicationList.MedList) {
        //find frequency object of medication.

        final Frequency freqOfMyMed = medItem.frequency.toString() != "null"
            ? FrequencyObjList.freqItems
                .where((x) => x.name == medItem.frequency)
                .first
            : Frequency.BuildFromFHIRRepeat(
                medItem.frequencyFHIRTimingRepeatObject as Map<String, dynamic>,
                medItem.frequencyText.toString());

        String thisMedItmNxtAdmin =
            medItem.getNextAdmin(DateTime.now(), freqOfMyMed);

        if ((DateFormat("d-M-yy H:m:ss")
                .parse(thisMedItmNxtAdmin)
                .toLocal()
                .difference(DateTime.now())
                .inMilliseconds) <=
            900000) {
          this.currentAdministrationList.add({
            medItem.medicationText.toString():
                DateFormat("d-M-yy H:m:ss").parse(thisMedItmNxtAdmin).toLocal()
          });
        }
      }
    });
  }
}
