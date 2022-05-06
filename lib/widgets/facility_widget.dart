import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:medsi/models/facility_model.dart';
import 'package:medsi/tasks/medication_list_fetch_process.dart';
import 'package:medsi/widgets/facility_detail.dart';
import 'package:medsi/provider_utils/facilities_provider.dart';

class FacilityWidget extends StatelessWidget {
  Facility facilityObj;
  FacilitiesProvider facilitiesListObjProv;
  FacilityWidget(
      {required this.facilityObj, required this.facilitiesListObjProv});

  @override
  Widget build(BuildContext context) {
    //final facilitiesListObj = Provider.of<FacilitiesProvider>(context);

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      FacilityDetail.routeName,
                      arguments: this.facilityObj,
                    );
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
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
                ),
              ],
            ),
            title: const Text(""),
            trailing: IconButton(
                alignment: Alignment.centerRight,
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('are you sure to delete this entry?'),
                          content: Text(this.facilityObj.name),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.amber,
                                  onSurface: Colors.cyanAccent),
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.amber,
                                  onSurface: Colors.cyanAccent),
                              child: Text("yes, delete"),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            )
                          ],
                        );
                      }).then((value) {
                    if (value == null) return;
                    if (value) {
                      facilitiesListObjProv.delete(this.facilityObj);
                    }
                  });
                },
                icon: const Icon(Icons.delete)),
          )
        ]));
  }
}
