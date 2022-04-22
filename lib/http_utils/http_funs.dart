import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MedsiHttp {
  Map<String, dynamic> bodyMap = {};
  Map<String, String> headerMap = {"Content-Type": "application/json"};
  Uri uriLink = Uri.parse("https://www.google.com");
  Function thenFunction;
  int timeoutSeconds = 5;
  var timeOutFunction;

  MedsiHttp(this.uriLink, this.bodyMap, this.thenFunction);

  void get() async {
    final theResponse = await http
        .get(this.uriLink, headers: this.headerMap)
        .then((value) => this.thenFunction(value))
        .timeout(Duration(seconds: this.timeoutSeconds),
            onTimeout: this.timeOutFunction);
  }

  void post() async {
    final theResponse = await http
        .post(this.uriLink,
            headers: this.headerMap, body: jsonEncode(this.bodyMap))
        .then((value) => this.thenFunction(value))
        .timeout(Duration(seconds: this.timeoutSeconds),
            onTimeout: this.timeOutFunction);
    //.timeout(Duration(seconds: 5),onTimeout:);
    ;
  }

  void postWithFiles(List<Map<String, Object>> filesAndPaths) async {
    var req = http.MultipartRequest('POST', this.uriLink);
    req.headers.addAll(this.headerMap);

    for (var fil in filesAndPaths) {
      String filName = fil["fileName"].toString();
      String filString = fil["filePath"].toString();
      File filObj = File(fil["filePath"].toString());

      req.files.add(http.MultipartFile(filName.toString(),
          filObj.readAsBytes().asStream(), filObj.lengthSync(),
          filename: filString.split("/").last));
    }

    var res = await req
        .send()
        .then((value) => this.thenFunction(value))
        .timeout(Duration(seconds: this.timeoutSeconds),
            onTimeout: this.timeOutFunction);
    ;
  }
}
