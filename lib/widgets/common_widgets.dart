import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LogonCommnon extends StatelessWidget {
  final userNameController = TextEditingController();
  final passWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Text("pass");
  }
}

AppBar MedsiAppBar = AppBar(title: Text("Medsi"));

CupertinoNavigationBar MedsiAppBarIOS =
    CupertinoNavigationBar(middle: const Text('Medsi'));
