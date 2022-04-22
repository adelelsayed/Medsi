import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../models/medication_model.dart';

class MedicationProvider extends Medication with ChangeNotifier {
  MedicationProvider(
      {required String MedicationNo,
      required String facility,
      required String medicationText,
      required String status,
      required String intent,
      String generic = "",
      String brand = "",
      String pack = "",
      String route = "",
      String strength = "",
      String form = "",
      String frequency = "",
      Map<String, dynamic> frequencyFHIRTimingRepeatObject = const {},
      String frequencyText = "",
      required int duration,
      required String durationunit,
      required String prescriber,
      required String prescriptionNo,
      required String startdatetime,
      required String lastqueried,
      required String ImageURL}) {
    this.MedicationNo = MedicationNo;
    this.facility = facility;
    this.medicationText = medicationText;
    this.status = status;
    this.intent = intent;
    this.generic = generic;
    this.brand = brand;
    this.pack = pack;
    this.route = route;
    this.strength = strength;
    this.form = form;
    this.frequency = frequency;
    this.frequencyText = frequencyText;
    this.frequencyFHIRTimingRepeatObject = frequencyFHIRTimingRepeatObject;
    this.duration = duration;
    this.durationunit = durationunit;
    this.prescriber = prescriber;
    this.prescriptionNo = prescriptionNo;
    this.startdatetime = DateTime.parse(startdatetime).toUtc();
    this.lastqueried = DateTime.parse(lastqueried).toUtc();
    this.ImageURL = ImageURL;

    notifyListeners();
  }
  //relying on date input string format to be 2022-02-02 08:49:00 +0500
  //produced from python by dt.datetime.strftime(<dt.datetime object>astimezone(),"%d-%m-%y %H:%M:%S %z")
}
