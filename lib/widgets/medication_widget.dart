import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import 'package:medsi/models/medication_model.dart';
import 'package:medsi/provider_utils/frequency_provider.dart';
import 'package:medsi/provider_utils/medication_provider.dart';
import 'package:medsi/models/frequency.dart';

class MedicationAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size MQuery = MediaQuery.of(context).size;
    final DateFormat formatter = DateFormat("d-M-yy hh:mm:ss");
    final MedicationItem = Provider.of<MedicationProvider>(context);
    final FrequencyObjList = Provider.of<FrequencyProvider>(context).freqItems;
    //find frequency object of medication.

    final Frequency freqOfMyMed = MedicationItem.frequency.toString() != "null"
        ? FrequencyObjList.where((x) => x.name == MedicationItem.frequency)
            .first
        : Frequency.BuildFromFHIRRepeat(
            MedicationItem.frequencyFHIRTimingRepeatObject
                as Map<String, dynamic>,
            MedicationItem.frequencyText.toString());

    final String nextAdmin =
        MedicationItem.getNextAdmin(DateTime.now(), freqOfMyMed);

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: GestureDetector(
                onTap: () {
                  // Navigator.of(context).pushNamed(
                  // ProductDetailScreen.routeName,
                  //arguments: product.id,
                  // );
                },
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                MedicationItem.medicationText.toString() +
                                    "\n" +
                                    (MedicationItem.brand.toString() != "null"
                                        ? MedicationItem.brand.toString()
                                        : "") +
                                    " " +
                                    (MedicationItem.generic.toString() != "null"
                                        ? MedicationItem.generic.toString()
                                        : "") +
                                    " " +
                                    (MedicationItem.route.toString() != "null"
                                        ? MedicationItem.route.toString()
                                        : "") +
                                    " " +
                                    (MedicationItem.form.toString() != "null"
                                        ? MedicationItem.form.toString()
                                        : "") +
                                    " " +
                                    (MedicationItem.strength.toString() !=
                                            "null"
                                        ? MedicationItem.strength.toString()
                                        : ""),
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Doctor: " +
                                    MedicationItem.prescriber.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                MedicationItem.facility.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.refresh_rounded),
                                Text(
                                  MedicationItem.lastqueried != null
                                      ? formatter.format(
                                          MedicationItem.lastqueried!.toLocal())
                                      : "",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 90,
                            width: 90,
                            child: Image.network(
                              MedicationItem.ImageURL.toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (context, exception, stackTrace) {
                                return Icon(Icons.image_not_supported);
                              },
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            GridTileBar(
              backgroundColor: Colors.blueAccent,
              leading: Row(
                children: [
                  /*
                  IconButton(
                    icon: const Icon(
                      Icons.schedule,
                      color: Colors.amberAccent,
                    ),
                    onPressed: () {
                      //product.toggleFavoriteStatus();
                    },
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.stop_circle_outlined,
                        color: Colors.deepOrangeAccent,
                      ),
                      onPressed: () {}),
                  const Icon(Icons.next_plan),
                  */
                  Text(
                    "${nextAdmin}",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              title: const Text(""),
              trailing: IconButton(
                alignment: Alignment.centerRight,
                icon: const Icon(
                  Icons.medication,
                  color: Colors.white70,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ));
  }
}
