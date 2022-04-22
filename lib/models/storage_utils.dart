import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

//secure storage
const medsiStorage = FlutterSecureStorage();

//temporary stub till server sude
void storagestub() async {
  medsiStorage.write(
      key: "SupportUrl", value: "http://192.168.0.128:8000/medsibe/support");

  //medsiStorage.delete(key: "Credentials");
  // medsiStorage.write(key: "Credentials", value: json.encode(["adel", "123456@b1"]));

  /*medsiStorage.write(
      key: "Facilities",
      value: json.encode([
        /* {
          "name": "General Hospital",
          "domain": "http://192.168.0.128:8000/medsibe/medslist",
          "mrn": 123
        },
        {
          "name": "Moon Clinic",
          "domain": "http://192.168.108.68:8000/medsibe/medslist",
          "mrn": 123
        },
        {
          "name": "Sun Pharmacy",
          "domain": "http://172.25.105.177:8000/medsibe/medslist",
          "mrn": 123
        },*/
        {
          "name": "Hapi Fhir",
          "authenticationurl": "",
          "medrequesturl":
              "https://hapi.fhir.org/baseR4/MedicationRequest/?_format=json&patient=",
          "patientidurl": "https://hapi.fhir.org/baseR4/Patient/?identifier=",
          "patientidentifier": "5791f6fc-11ab-e632-5fd7-3135662b1b44xxxx-555",
          "patientId": ""
        }
      ]));
  */
  medsiStorage.write(
      key: "JsonValidationSchemes",
      value: json.encode({
        "BundleScheme": {
          "resourceType": ["String", true],
          "id": ["String", true],
          "meta": ["_InternalLinkedHashMap<String, dynamic>", false],
          "link": ["List<dynamic>", false],
          "entry": ["List<dynamic>", true]
        },
        "SingleEntryScheme": {
          "fullUrl": ["String", false],
          "resource": ["_InternalLinkedHashMap<String, dynamic>", true],
          "search": ["_InternalLinkedHashMap<String, dynamic>", false]
        },
        "PatientResourceScheme": {
          "resourceType": [
            "String",
            true,
            ["Patient"]
          ],
          "id": ["String", true],
          "meta": ["_InternalLinkedHashMap<String, dynamic>", false],
          "name": ["List<dynamic>", false],
          "identifier": ["List<dynamic>", false],
          "telecom": ["List<dynamic>", false],
          "address": ["List<dynamic>", false],
          "gender": ["String", false],
          "birthdate": ["String", false],
        },
        "MedRequestResourceScheme": {
          "resourceType": [
            "String",
            true,
            ["MedicationRequest"]
          ],
          "id": ["String", true],
          "meta": ["_InternalLinkedHashMap<String, dynamic>", false],
          "intent": [
            "String",
            true,
            [
              "proposal",
              "plan",
              "order",
              "original-order",
              "reflex-order",
              "filler-order",
              "instance-order",
              "option"
            ]
          ],
          "status": [
            "String",
            true,
            [
              "active",
              "on-hold",
              "cancelled",
              "completed",
              "entered-in-error",
              "stopped",
              "draft",
              "unknown"
            ]
          ],
          "medicationCodeableConcept": [
            "_InternalLinkedHashMap<String, dynamic>",
            true
          ],
          "subject": ["_InternalLinkedHashMap<String, dynamic>", false],
          "encounter": ["_InternalLinkedHashMap<String, dynamic>", true],
          "authoredOn": ["String", true],
          "requester": ["_InternalLinkedHashMap<String, dynamic>", true],
          "reasonReference": ["List<dynamic>", false],
          "dosageInstruction": ["List<dynamic>", true],
          //reference : https://simplifier.net/packages/nictiz.fhir.nl.stu3.zib2017/1.3.12/files/347638
          "extension": ["_InternalLinkedHashMap<String, Object>", true]
        },
        "MedicationCodeableConceptScheme": {
          "text": ["String", true],
          "coding": ["List<dynamic>", true]
        },
        "DosageInstructionScheme": {
          "timing": ["_InternalLinkedHashMap<String, dynamic>", true],
          "doseAndRate": ["List<dynamic>", true],
          "asNeededBoolean": ["bool", true],
        },
        "extension": {
          "durationCode": [
            "String",
            true,
            ["d", "w", "m", "y"]
          ],
          "durationNumber": ["int", true],
          "prescriptionNo": ["String", true],
          "ImageURL": ["String", false]
        }
      }));

  medsiStorage.write(
      key: "FrequencySchedule",
      value: json.encode([
        {
          "once": ["Once"]
        },
        {
          "BID": [
            "Static",
            "Day",
            "",
            ["09:00:00", "21:00:00"]
          ]
        },
        {
          "Every 8 Hours": ["Dynamic", "Day", "3", []]
        },
        {
          "Once Daily": [
            "Static",
            "Day",
            "",
            ["10:00:00"]
          ]
        }
      ]));

  medsiStorage.write(key: "AdministrationList_intervalMinutes", value: "5");
  medsiStorage.write(key: "MedicationListProcess_intervalMinutes", value: "5");
}
