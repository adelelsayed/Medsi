class FHIRToMedsiConverter {
  Map<String, dynamic> fhirMap;
  Map<String, dynamic> medsiMap = {};
  String currentMedId = "";

  FHIRToMedsiConverter({required this.fhirMap});

  void convert() {
    this.currentMedId = this.fhirMap["id"];
    this.medsiMap["medicationNo"] = this.fhirMap["id"];
    this.medsiMap["medicationText"] =
        this.fhirMap["medicationCodeableConcept"]["text"];
    this.medsiMap["prescriber"] = this.fhirMap["requester"]["display"];
    this.medsiMap["startdatetime"] = this.fhirMap["authoredOn"];
    this.medsiMap["duration"] = this.fhirMap["extension"]["durationNumber"];
    this.medsiMap["durationunit"] = this.fhirMap["extension"]["durationCode"];
    this.medsiMap["prescriptionNo"] =
        this.fhirMap["extension"]["prescriptionNo"];
    this.medsiMap["ImageURL"] = this.fhirMap["extension"]["ImageURL"];

    if (Map<String, dynamic>.from(this.fhirMap["extension"])
        .containsKey("frequencyCode")) {
      this.medsiMap["frequency"] = this.fhirMap["extension"]["frequencyCode"];
    } else {
      if (Map<String, dynamic>.from(
              this.fhirMap["dosageInstruction"][0]["timing"])
          .containsKey("repeat")) {
        this.medsiMap["frequencyFHIRTimingRepeatObject"] =
            this.fhirMap["dosageInstruction"][0]["timing"]["repeat"];
      } else {
        this.medsiMap["frequencyText"] =
            this.fhirMap["dosageInstruction"][0]["timing"]["code"]["text"];
      }
    }
  }
}
