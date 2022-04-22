class MedsiNotification {
  int id;
  String title;
  String subject;

  MedsiNotification(
      {required this.id, required this.title, required this.subject});
}

class MedsiNotificationChannel {
  String id;
  String name;

  MedsiNotificationChannel({required this.id, required this.name});
}
