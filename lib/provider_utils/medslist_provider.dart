import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:developer';

import '../models/storage_utils.dart';
import '../provider_utils/medication_provider.dart';

class MedicationList with ChangeNotifier {
  List<MedicationProvider> MedList = [];

  Future<void> getMedList({bool notify_listeners = true}) async {
    dynamic ListOfMeds = await medsiStorage.read(key: "MedsList");

    var ListOfMedsConvi = json.decode(ListOfMeds);
    Map<String, dynamic> ListOfMedsConv =
        Map<String, dynamic>.from(ListOfMedsConvi);

    List<MedicationProvider> holder = [];

    if (ListOfMedsConv.isNotEmpty) {
      ListOfMedsConv.forEach((k, facility) {
        facility = Map<String, Object>.from(facility);
        if (facility.isNotEmpty &&
            facility.containsKey("Facility") &&
            facility.containsKey("TimeOfQuery") &&
            facility.containsKey("MedsList")) {
          Map<String, dynamic> medsList =
              Map<String, dynamic>.from(facility["MedsList"]);
          medsList.forEach((ki, dynamic med) {
            holder.add(MedicationProvider(
                MedicationNo: med["medicationNo"].toString(),
                facility: facility["Facility"].toString(),
                medicationText: med["medicationText"].toString(),
                status: med["status"].toString(),
                intent: med["intent"].toString(),
                generic: med["generic"].toString(),
                brand: med["brand"].toString(),
                pack: med["pack"].toString(),
                route: med["route"].toString(),
                strength: med["strength"].toString(),
                form: med["form"].toString(),
                frequency: med["frequency"].toString(),
                frequencyText: med["frequencyText"].toString(),
                frequencyFHIRTimingRepeatObject: Map<String, dynamic>.from(
                    med["frequencyFHIRTimingRepeatObject"]),
                duration: int.parse(med["duration"].toString()),
                durationunit: med["durationunit"].toString(),
                prescriber: med["prescriber"].toString(),
                prescriptionNo: med["prescriptionNo"].toString(),
                startdatetime: med["startdatetime"].toString(),
                lastqueried: facility["TimeOfQuery"].toString(),
                ImageURL: med["ImageURL"].toString()));
          });
        }
      });
      this.MedList = holder;

      if (notify_listeners) {
        notifyListeners();
      }
    }
  }
}
