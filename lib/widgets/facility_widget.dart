import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medsi/models/facility_model.dart';
import 'package:medsi/tasks/medication_list_fetch_process.dart';

class FacilityWidget extends StatelessWidget {
  Facility facilityObj;
  FacilityWidget({required this.facilityObj});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          child: Text(
                            facilityObj.name,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ]))),
          GridTileBar(
            backgroundColor: Colors.blueAccent,
            leading: Row(
              children: [
                IconButton(
                  onPressed: () {
                    MedicationListProcess.getPatientId(facilityObj.patientidurl,
                        facilityObj.patientidentifier, facilityObj.name);
                  },
                  icon: const Icon(
                    Icons.refresh,
                    semanticLabel: "Refresh Patient Id",
                  ),
                  tooltip: "Refresh Patient Id",
                )
              ],
            ),
            title: Text(" "),
          )
        ]));
  }
}
