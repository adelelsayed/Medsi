import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import './common_widgets.dart';
import '../provider_utils/auth_provider.dart';
import 'package:medsi/views/medication_list_view.dart';
import 'package:medsi/views/logon_view.dart';

class LogonIOS extends LogonCommnon {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Auth myAuth = Provider.of<Auth>(context);
    myAuth.setCredentials();

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            const Text("Please Fill in Your Credentials"),
            CupertinoTextFormFieldRow(
                decoration: const BoxDecoration(),
                placeholder: "username",
                controller: userNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
            CupertinoTextFormFieldRow(
                decoration: const BoxDecoration(),
                placeholder: "password",
                controller: passWordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
            CupertinoTextFormFieldRow(
                decoration: const BoxDecoration(),
                placeholder: "email",
                controller: emailController,
                obscureText: false,
                readOnly: myAuth.registerationState == "Logon",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Valid Email Address';
                  }
                  return null;
                }),
            CupertinoTextFormFieldRow(
                decoration: const BoxDecoration(),
                placeholder: "phone number",
                controller: phoneNumberController,
                readOnly: myAuth.registerationState == "Logon",
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Phone Number';
                  }
                  return null;
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (myAuth.registerationState == "Logon") {
                        if (myAuth.authenticateLocal(
                            userNameController.text, passWordController.text)) {
                          ScaffoldMessenger.of(context).clearSnackBars();

                          Navigator.of(context).pushReplacementNamed(
                              MedicationListView.routeName);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Processing Data'),
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                      } else if (myAuth.registerationState == "Register") {
                        myAuth
                            .writeCredentials(
                                userNameController.text,
                                passWordController.text,
                                emailController.text,
                                phoneNumberController.text)
                            .then((value) {
                          myAuth.registerationState = "Logon";
                          Navigator.of(context)
                              .pushReplacementNamed(MedsiLogonView.routeName);
                        });
                      }
                    }
                  },
                  child: const Text("Login")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                  onPressed: () {}, child: const Text("Register")),
            ),
          ]),
        ));
  }
}
