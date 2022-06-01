import 'dart:developer';
import 'dart:convert';
import 'package:medsi/http_utils/http_funs.dart';
import 'package:medsi/models/storage_utils.dart';
import 'package:medsi/provider_utils/auth_provider.dart';

Future<void> logonCallback() async {
  log("logonCallback");

  Auth myAuth = Auth();
  myAuth.setCredentials();

  dynamic facilities = await Auth.getListOfFacilities();

  List<Map<String, dynamic>> facilitiesConv =
      List<Map<String, dynamic>>.from(json.decode(facilities));

  List<Map<String, dynamic>> facilitiesConvNew = facilitiesConv;

  for (Map<String, dynamic> facilitiesConvElement in facilitiesConv) {
    int currentIdx = facilitiesConv.indexOf(facilitiesConvElement);
    String authUriString = facilitiesConvElement["authenticationurl"];

    MedsiHttp authRequest = MedsiHttp(Uri.parse(authUriString), {
      "username": facilitiesConvElement["facilityusername"],
      "password": facilitiesConvElement["facilitypassword"]
    }, (response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseConverted = json.decode(response.body);

        String currentToken = responseConverted["Token"];
        facilitiesConvElement.update("Token", (value) => currentToken,
            ifAbsent: () => currentToken);

        facilitiesConvNew.removeAt(currentIdx);
        facilitiesConvNew.insert(currentIdx, facilitiesConvElement);
        medsiStorage.write(
            key: "Facilities", value: json.encode(facilitiesConvNew));
      } else {}
    });

    authRequest.post();
  }
}
