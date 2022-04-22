import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:medsi/models/storage_utils.dart';
import 'package:medsi/views/logon_view.dart';
import 'package:medsi/widgets/common_widgets.dart';
import 'package:medsi/http_utils/http_funs.dart';

class MedsiErrorWidget extends StatelessWidget {
  String MessageOfError;
  MedsiErrorWidget({required this.MessageOfError});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MedsiAppBar,
      body: Container(
          child: Column(
        children: [
          Text(this.MessageOfError),
          ElevatedButton.icon(
              onPressed: () async {
                //read logger file
                //send it to support url

                medsiStorage.read(key: "Logger").then((log) {
                  if (log != null) {
                    medsiStorage.read(key: "SupportUrl").then((supportURL) {
                      if (supportURL != null) {
                        MedsiHttp myHttp = MedsiHttp(
                            Uri.parse(supportURL), {"SupportLog": log}, () {});
                        myHttp.post();
                      }
                    });
                  }
                });
                Navigator.of(context)
                    .pushReplacementNamed(MedsiLogonView.routeName);
              },
              icon: const Icon(Icons.upload_file),
              label: const Text("Send Logs to Support"))
        ],
      )),
    );
  }
}
