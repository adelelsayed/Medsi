class MedicationAdminisration {
  String id;
  String medicationNo;
  DateTime plannedDatetime;
  DateTime administeredDatetime;
  String dose;

  MedicationAdminisration(
      {required this.id,
      required this.medicationNo,
      required this.plannedDatetime,
      required this.administeredDatetime,
      required this.dose});
}
