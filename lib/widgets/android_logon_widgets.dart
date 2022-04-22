import 'package:flutter/material.dart';
import 'package:medsi/views/medication_list_view.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import './common_widgets.dart';
import '../provider_utils/auth_provider.dart';
import 'package:medsi/views/logon_view.dart';

class LogonAndroid extends LogonCommnon {
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text("Please Fill in Your Credentials"),
                TextFormField(
                    decoration: const InputDecoration(
                        labelText: "username", icon: Icon(Icons.person)),
                    controller: userNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter UserName';
                      }
                      return null;
                    }),
                TextFormField(
                    decoration: const InputDecoration(
                        labelText: "password", icon: Icon(Icons.person)),
                    controller: passWordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter PassWord';
                      }
                      return null;
                    }),
                Visibility(
                  visible: myAuth.registerationState == "Register",
                  child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: "email", icon: Icon(Icons.person)),
                      controller: emailController,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Valid Email Address';
                        }
                        return null;
                      }),
                ),
                Visibility(
                  visible: myAuth.registerationState == "Register",
                  child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: "phone", icon: Icon(Icons.person)),
                      controller: phoneNumberController,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Phone Number';
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (myAuth.registerationState == "Logon") {
                            if (myAuth.authenticateLocal(
                                userNameController.text,
                                passWordController.text)) {
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
                              Navigator.of(context).pushReplacementNamed(
                                  MedsiLogonView.routeName);
                            });
                          }
                        }
                      },
                      icon: const Icon(Icons.login),
                      label: Text(myAuth.registerationState)),
                ),
              ]),
        ));
  }
}
