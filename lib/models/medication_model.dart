import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:medsi/models/frequency.dart';
import 'package:medsi/utils/frequency_dynamic_utils.dart';
import 'package:medsi/utils/frequency_static_utils.dart';

class Medication {
  String? MedicationNo;
  String? facility;
  String? medicationText;
  String? status;
  String? intent;
  String? generic;
  String? brand;
  String? pack;
  String? route;
  String? strength;
  String? form;
  String? frequency;
  Map<String, dynamic>? frequencyFHIRTimingRepeatObject;
  String? frequencyText;
  int? duration;
  // as small letter (d for days, w for weeks, m for months, y for years)
  String? durationunit;
  String? prescriber;
  String? prescriptionNo;
  DateTime? startdatetime;
  DateTime? lastqueried;
  String? ImageURL;
  bool? isVariableAdmin;
  List<String>? variableAdminList;
  // list of Map {planned time : actual time}
  List<Map<String, String>> rescheduleList = [];

  DateTime get endDatetime {
    DateTime endDate = DateTime.now();

    DateTime startDate = this.startdatetime as DateTime;

    switch (this.durationunit) {
      case "d":
        endDate = DateTime(
            startDate.year,
            startDate.month,
            startDate.day + this.duration!,
            startDate.hour,
            startDate.minute,
            startDate.second);
        break;
      case "w":
        endDate = DateTime(
            startDate.year,
            startDate.month,
            startDate.day + (7 * this.duration!),
            startDate.hour,
            startDate.minute,
            startDate.second);
        break;
      case "m":
        endDate = DateTime(startDate.year, startDate.month + this.duration!,
            startDate.day, startDate.hour, startDate.minute, startDate.second);
        break;
      case "y":
        endDate = DateTime(startDate.year + this.duration!, startDate.month,
            startDate.day, startDate.hour, startDate.minute, startDate.second);
        break;
    }

    return endDate;
  }

  String getNextAdmin(DateTime zerPoint, Frequency freqObj) {
    final DateFormat formatter = DateFormat("d-M-yy H:m:s");

    String retVal =
        "Couldn't Calculate Next Administration Time, Contact Support!";

    DateTime endDate = this.endDatetime;
    DateTime startDate = this.startdatetime as DateTime;

    if (endDate.isBefore(DateTime.now())) {
      retVal = "Order Ended";
    } else if (freqObj.isOnce) {
      retVal = "Once";
    } else if (freqObj.isDynamic) {
      retVal = formatter.format(getDynamicDate(freqObj, startDate));
    } else if (freqObj.isStatic) {
      retVal = formatter.format(getStaticDate(freqObj, startDate));
    }
    if (rescheduleList.isNotEmpty) {
      rescheduleList.forEach((element) {
        if (element.containsKey(retVal)) {
          retVal = element[retVal] as String;
        }
      });
    }

    return retVal;
  }
}
