import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:medsi/provider_utils/medslist_provider.dart';
import 'package:medsi/widgets/medication_widget.dart';

class MedicationListAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MedsList = Provider.of<MedicationList>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, indx) => ChangeNotifierProvider.value(
              value: MedsList.MedList[indx],
              child: MedicationAndroid(),
            ),
            itemCount: MedsList.MedList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}

class MedicationListIOS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MedsList = Provider.of<MedicationList>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, indx) => ChangeNotifierProvider.value(
              value: MedsList.MedList[indx],
              child: MedicationAndroid(),
            ),
            itemCount: MedsList.MedList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
