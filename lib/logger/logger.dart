import 'package:medsi/models/storage_utils.dart';
import 'dart:convert';

class Logger {
  DateTime logDate = DateTime.now().toUtc();
  String logModule = "LoggerItem";
  String logMessage = "";
  String logKey = DateTime.now().millisecond.toString() + "Logger Key";
  bool isWritten = false;

  Logger(DateTime plogDate, String plogModule, String plogMessage) {
    this.logDate = plogDate.toUtc();
    this.logModule = plogModule;
    this.logMessage = plogMessage;
    this.logKey = this.logDate.microsecond.toString() + " : " + this.logModule;
  }

  static void logMe(String FunctionName, String Message) async {
    try {
      Logger thisLog = Logger(DateTime.now(), FunctionName, Message);

      List LogList = [];

      medsiStorage.containsKey(key: "Logger").then((ifvalue) {
        if (ifvalue) {
          medsiStorage.read(key: "Logger").then((listString) {
            List LogList = json.decode(listString.toString());

            LogList.add({
              thisLog.logKey: {
                thisLog.logModule: [thisLog.logDate, thisLog.logMessage]
              }
            });
          });
        }
      });

      medsiStorage
          .write(key: "Logger", value: json.encode(LogList))
          .then((value) => thisLog.isWritten = true);
    } catch (eError) {
      medsiStorage.write(
          key: DateTime.now().toUtc().microsecond.toString() +
              " : " +
              "error during logMe",
          value: json.encode({
            "error during logMe " + FunctionName: [
              DateTime.now().toUtc().toString(),
              Message + " : " + eError.toString()
            ]
          }));
    }
  }
}
