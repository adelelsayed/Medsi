import 'dart:convert';
import 'dart:developer';

import 'package:medsi/models/storage_utils.dart';
import 'package:medsi/utils/json_validator.dart';

abstract class FHIRResource {
  Map<String, dynamic> fhirMap = {};
  List<String> ErrorMessage = [];
  bool isvalid = true;

  Future<void> validate() async {}
}

class FHIRBundle extends FHIRResource {
  FHIRBundle(dynamic pfhirMap) {
    this.fhirMap = Map<String, dynamic>.from(pfhirMap);
  }

  @override
  Future<void> validate() async {
    await medsiStorage
        .read(key: "JsonValidationSchemes")
        .then((rawJsonSchemas) {
      Map<String, dynamic> JsonSchemas = json.decode(rawJsonSchemas.toString());
      Map<String, List<dynamic>> BundleScheme =
          Map<String, List<dynamic>>.from(JsonSchemas["BundleScheme"]);
      JsonValidatorByScheme ValidationObj =
          JsonValidatorByScheme(BundleScheme, this.fhirMap);
      if (!ValidationObj.isValid()) {
        this.isvalid = false;
        this.ErrorMessage.add("not a valid fhir resource: " +
            ValidationObj.ErrorFlags.toString());
        return;
      }
    });
  }
}

class FHIRPatientRequest extends FHIRResource {
  FHIRPatientRequest(dynamic pfhirMap) {
    this.fhirMap = Map<String, dynamic>.from(pfhirMap);
  }

  @override
  Future<void> validate() async {
    await medsiStorage
        .read(key: "JsonValidationSchemes")
        .then((rawJsonSchemas) {
      Map<String, dynamic> JsonSchemas = json.decode(rawJsonSchemas.toString());

      Map<String, List<dynamic>> PatRequestScheme =
          Map<String, List<dynamic>>.from(JsonSchemas["SingleEntryScheme"]);
      JsonValidatorByScheme ValidationObj =
          JsonValidatorByScheme(PatRequestScheme, this.fhirMap);
      if (!ValidationObj.isValid()) {
        this.isvalid = false;
        this.ErrorMessage.add("not a valid fhir resource: " +
            ValidationObj.ErrorFlags.toString());
        return;
      }

      Map<String, List<dynamic>> PatResourceScheme =
          Map<String, List<dynamic>>.from(JsonSchemas["PatientResourceScheme"]);
      JsonValidatorByScheme ValidationObj1 =
          JsonValidatorByScheme(PatResourceScheme, this.fhirMap["resource"]);
      if (!ValidationObj1.isValid()) {
        this.isvalid = false;
        this.ErrorMessage.add("not a valid patient fhir resource: " +
            ValidationObj1.ErrorFlags.toString());
        return;
      }
    });
  }
}

class FHIRMedRequest extends FHIRResource {
  FHIRMedRequest(dynamic pfhirMap) {
    this.fhirMap = Map<String, dynamic>.from(pfhirMap);
  }

  @override
  Future<void> validate() async {
    await medsiStorage
        .read(key: "JsonValidationSchemes")
        .then((rawJsonSchemas) {
      Map<String, dynamic> JsonSchemas = json.decode(rawJsonSchemas.toString());

      Map<String, List<dynamic>> MedRequestScheme =
          Map<String, List<dynamic>>.from(JsonSchemas["SingleEntryScheme"]);
      JsonValidatorByScheme ValidationObj =
          JsonValidatorByScheme(MedRequestScheme, this.fhirMap);
      if (!ValidationObj.isValid()) {
        this.isvalid = false;
        this.ErrorMessage.add("not a valid fhir resource: " +
            ValidationObj.ErrorFlags.toString());
        return;
      }

      Map<String, List<dynamic>> MedRequestResourceScheme =
          Map<String, List<dynamic>>.from(
              JsonSchemas["MedRequestResourceScheme"]);
      JsonValidatorByScheme ValidationObj1 = JsonValidatorByScheme(
          MedRequestResourceScheme,
          Map<String, dynamic>.from(this.fhirMap["resource"]));
      if (!ValidationObj1.isValid()) {
        this.isvalid = false;
        this.ErrorMessage.add("not a valid Medication Request fhir resource: " +
            ValidationObj1.ErrorFlags.toString());
        return;
      }

      Map<String, List<dynamic>> MedicationCodeableConceptScheme =
          Map<String, List<dynamic>>.from(
              JsonSchemas["MedicationCodeableConceptScheme"]);
      JsonValidatorByScheme ValidationObj2 = JsonValidatorByScheme(
          MedicationCodeableConceptScheme,
          Map<String, dynamic>.from(
              this.fhirMap["resource"]["medicationCodeableConcept"]));
      if (!ValidationObj2.isValid()) {
        this.isvalid = false;
        this.ErrorMessage.add("not a valid medicationCodeableConcept: " +
            ValidationObj2.ErrorFlags.toString());
        return;
      }

      Map<String, List<dynamic>> DosageInstructionScheme =
          Map<String, List<dynamic>>.from(
              JsonSchemas["DosageInstructionScheme"]);
      JsonValidatorByScheme ValidationObj3 = JsonValidatorByScheme(
          DosageInstructionScheme,
          Map<String, dynamic>.from(
              this.fhirMap["resource"]["dosageInstruction"][0]));
      if (!ValidationObj3.isValid()) {
        this.isvalid = false;
        this.ErrorMessage.add("not a valid dosageInstruction: " +
            ValidationObj3.ErrorFlags.toString());
        return;
      }

      Map<String, List<dynamic>> DurationScheme =
          Map<String, List<dynamic>>.from(JsonSchemas["extension"]);
      JsonValidatorByScheme ValidationObj4 = JsonValidatorByScheme(
          DurationScheme,
          Map<String, dynamic>.from(this.fhirMap["resource"]["extension"]));
      if (!ValidationObj4.isValid()) {
        this.isvalid = false;
        this.ErrorMessage.add("not a valid dosageInstruction: " +
            ValidationObj4.ErrorFlags.toString());
        return;
      }

      this.fhirMap["resource"]["dosageInstruction"][0]["timing"] =
          Map<String, dynamic>.from(
              this.fhirMap["resource"]["dosageInstruction"][0]["timing"]);

      if (((!this
                  .fhirMap["resource"]["dosageInstruction"][0]["timing"]
                  .keys
                  .contains("repeat")) &&
              (!this
                  .fhirMap["resource"]["dosageInstruction"][0]["timing"]
                  .keys
                  .contains("code"))) ||
          ((this
                  .fhirMap["resource"]["dosageInstruction"][0]["timing"]
                  .keys
                  .contains("code")) &&
              (!this
                  .fhirMap["resource"]["dosageInstruction"][0]["timing"]["code"]
                  .keys
                  .contains("text"))) ||
          (!this
              .fhirMap["resource"]["dosageInstruction"][0]["doseAndRate"][0]
              .keys
              .contains("doseQuantity"))) {
        this.isvalid = false;
        this.ErrorMessage.add("dosageInstruction timing and dose are invalid");
        return;
      }

      List<String> requiredAtLeastOneKeyTiming = ["frequency", "when", "count"];
      List<int> timingChk = [];
      for (var timingKey in requiredAtLeastOneKeyTiming) {
        if (!this
            .fhirMap["resource"]["dosageInstruction"][0]["timing"]["repeat"]
            .keys
            .contains(timingKey)) {
          timingChk.add(0);
        } else {
          timingChk.add(1);
        }
      }

      if (!timingChk.contains(1) &&
          !((this.fhirMap["resource"]["dosageInstruction"][0]["timing"]
                  ["code"]) &&
              (this.fhirMap["resource"]["dosageInstruction"][0]["timing"]
                  ["code"]["text"]))) {
        this.isvalid = false;
        this.ErrorMessage.add("timing is invalid, timing repeat is invalid");
        return;
      }
    });
  }
}
