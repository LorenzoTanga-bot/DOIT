import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

const kPass = "Doit";

class BasicAuthConfig {
  static final BasicAuthConfig _singleton = BasicAuthConfig._internal();

  factory BasicAuthConfig() {
    return _singleton;
  }

  BasicAuthConfig._internal();

  Map<String, String> getBaseHeader() {
    return {"content-type": "application/json", "accept": "application/json"};
  }

  Future<Map<String, String>> getUserHeader() async {
    String userMail = (await FirebaseAuth.instance.currentUser()).email;
    var credentials = base64.encode(utf8.encode("$userMail:$kPass"));
    return {
      "content-type": "application/json",
      "accept": "application/json",
      "authorization": "Basic $credentials"
    };
  }

  Future<Map<String, String>> getSudoHeader() async {
    var credentials = base64.encode(utf8.encode("sudo@mail.com:$kPass"));
    return {
      "content-type": "application/json",
      "accept": "application/json",
      "authorization": "Basic $credentials"
    };
  }
}
