import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medsi/models/system_settings.dart';
import 'package:medsi/views/facilities_view.dart';
import 'package:medsi/views/medication_list_view.dart';
import 'package:medsi/views/logon_view.dart';

class SystemSettingsWidget extends StatelessWidget {
  static String routeName = "SystemSettings";
  TextEditingController administrationInterval = TextEditingController();
  TextEditingController medicationListInterval = TextEditingController();
  TextEditingController logoProcessInterval = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Settings systemSettingsProvider = Provider.of<Settings>(context);

    this.administrationInterval = TextEditingController(
        text: systemSettingsProvider.administrationListIntervalMinutes
            .toString());
    this.logoProcessInterval = TextEditingController(
        text: systemSettingsProvider.logonProcessIntervalMinutes.toString());
    this.medicationListInterval = TextEditingController(
        text: systemSettingsProvider.medicationListProcessIntervalMinutes
            .toString());

    return Scaffold(
        appBar: AppBar(title: const Text("Medsi"), actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(MedicationListView.routeName);
              },
              icon: const Icon(Icons.medication)),
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(FacilitiesView.routeName);
              },
              icon: const Icon(Icons.local_hospital)),
          IconButton(
              onPressed: (() => Navigator.of(context)
                  .pushReplacementNamed(MedsiLogonView.routeName)),
              icon: const Icon(Icons.logout))
        ]),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                  TextFormField(
                      decoration: const InputDecoration(
                          labelText:
                              "Interval Minutes For Administration Notification",
                          icon: Icon(Icons.access_alarm)),
                      controller: administrationInterval,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null) {
                          return 'Please enter Number Of Minutes to Check for Due Administrations';
                        }
                        return null;
                      }),
                  TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Interval Minutes For Medications Check",
                          icon: Icon(Icons.check_circle)),
                      controller: medicationListInterval,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null) {
                          return 'Please enter Number Of Minutes to Check for new Medications';
                        }
                        return null;
                      }),
                  TextFormField(
                      decoration: const InputDecoration(
                          labelText:
                              "Interval Minutes For Authorization Requests",
                          icon: Icon(Icons.fact_check)),
                      controller: logoProcessInterval,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null) {
                          return 'Please enter Number Of Minutes to request Access Token';
                        }
                        return null;
                      }),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Settings.setSystemIntervals(
                                      systemSettingsProvider,
                                      int.parse(administrationInterval.text),
                                      int.parse(medicationListInterval.text),
                                      int.parse(logoProcessInterval.text))
                                  .then((value) {
                                Navigator.of(context).pushReplacementNamed(
                                    MedicationListView.routeName);
                              });
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text("Submit")))
                ]))));
  }
}
