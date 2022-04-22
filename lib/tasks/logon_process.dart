import 'dart:developer';

import 'package:medsi/http_utils/http_funs.dart';
import 'package:medsi/provider_utils/auth_provider.dart';

void logonCallback() {
  log("logonCallback");

  Auth myAuth = Auth();
  myAuth.setCredentials();
}
