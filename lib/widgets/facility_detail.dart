import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medsi/models/facility_model.dart';
import 'package:medsi/provider_utils/facilities_provider.dart';
import 'package:provider/provider.dart';

class FacilityDetail extends StatelessWidget {
  static String routeName = "FacilityDetail";
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController patientidentifierController = TextEditingController();
  TextEditingController patientidurlController = TextEditingController();
  TextEditingController authenticationurlController = TextEditingController();
  TextEditingController medrequesturlController = TextEditingController();

  late Facility facilityObj;

  @override
  Widget build(BuildContext context) {
    final facilitiesListObj =
        Provider.of<FacilitiesProvider>(context, listen: false);

    final Facility facilityObject =
        ModalRoute.of(context)!.settings.arguments as Facility;
    this.facilityObj = facilityObject;
    this.nameController = TextEditingController(text: facilityObject.name);
    this.authenticationurlController =
        TextEditingController(text: facilityObject.authenticationurl);
    this.medrequesturlController =
        TextEditingController(text: facilityObject.medrequesturl);
    this.patientidentifierController =
        TextEditingController(text: facilityObject.patientidentifier);
    this.patientidurlController =
        TextEditingController(text: facilityObject.patientidurl);

    return Scaffold(
      appBar: AppBar(title: const Text("Medsi")),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Facility Name",
                        icon: Icon(Icons.local_hospital)),
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Facility Name';
                      }
                      return null;
                    }),
                TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Patient Identifier at this Facility",
                        icon: Icon(Icons.perm_identity)),
                    controller: patientidentifierController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Patient Identifier at this facility';
                      }
                      return null;
                    }),
                TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Patient Id URL", icon: Icon(Icons.link)),
                    controller: patientidurlController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Patient Id URL for this facility';
                      }
                      return null;
                    }),
                TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Authentication URL",
                        icon: Icon(Icons.link)),
                    controller: authenticationurlController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Authentocation URL';
                      }
                      return null;
                    }),
                TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Medication List URL",
                        icon: Icon(Icons.link)),
                    controller: medrequesturlController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Medication List URL';
                      }
                      return null;
                    }),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            bool hasChanged = (this.facilityObj.name !=
                                    nameController.text) ||
                                (this.facilityObj.authenticationurl !=
                                    authenticationurlController.text) ||
                                (this.facilityObj.patientidentifier !=
                                    patientidentifierController.text) ||
                                (this.facilityObj.patientidurl !=
                                    patientidurlController.text) ||
                                (this.facilityObj.medrequesturl !=
                                    medrequesturlController.text);

                            if (hasChanged) {
                              Facility newFacilityObj = Facility(
                                  nameController.text,
                                  authenticationurlController.text,
                                  medrequesturlController.text,
                                  patientidurlController.text,
                                  patientidentifierController.text);

                              facilitiesListObj
                                  .setFacilites(
                                      this.facilityObj, newFacilityObj)
                                  .then((value) => Navigator.of(context).pop());
                            }
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text("Submit")))
              ]))),
    );
  }
}
