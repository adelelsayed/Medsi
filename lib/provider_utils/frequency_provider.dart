import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:device_information/device_information.dart';

import '../http_utils/http_funs.dart';
import '../models/storage_utils.dart';
import 'package:medsi/models/frequency.dart';

class FrequencyProvider with ChangeNotifier {
  List<Frequency> freqItems = [];

  void readFreqListIntoFreqObj({bool notify_listeners = true}) async {
    List<dynamic> freqMapList = [];
    var reader = await medsiStorage.read(key: "FrequencySchedule");
    if (reader != null) {
      freqMapList = json.decode(reader);

      for (var item in freqMapList) {
        item = item as Map<String, dynamic>;
        Frequency ItemObj;
        List<dynamic> valueList = item.values.toList();

        if (valueList.first.first == "Once") {
          ItemObj = Frequency.Once(item.keys.first);
          this.freqItems.add(ItemObj);
        } else if (valueList.first.first == "Dynamic") {
          ItemObj = Frequency.Dynamic(item.keys.first,
              valueList.first[1].toString(), int.parse(valueList.first[2]));
          this.freqItems.add(ItemObj);
        } else if (valueList.first.first == "Static") {
          List<String> TimesList = (valueList.first[3] as List<dynamic>)
              .map((e) => e.toString())
              .toList();

          ItemObj = Frequency.Static(
              item.keys.first, valueList.first[1].toString(), TimesList);
          this.freqItems.add(ItemObj);
        } else {
          throw Exception("UnIdentified Frequency ${item.toString()}!");
        }
      }
    }
    if (notify_listeners) {
      notifyListeners();
    }
  }
}
