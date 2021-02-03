import 'dart:convert';

import 'package:doit/model/AuthCredential.dart';

const aMail = "sudo@mail.com";
const aPsw = "Doit";

class BasicAuthConfig {
  static final BasicAuthConfig _singleton = BasicAuthConfig._internal();
  AuthCredential _authCredential;

  factory BasicAuthConfig() {
    return _singleton;
  }

  BasicAuthConfig._internal();

  bool setAuthCredential(AuthCredential authCredential) {
    _authCredential = authCredential;
    return true;
  }

  AuthCredential getAuthCredential() {
    return _authCredential;
  }

  bool deleteAuthCredential() {
    _authCredential = null;
    return true;
  }

  Map<String, String> getBaseHeader() {
    return {"content-type": "application/json", "accept": "application/json"};
  }

  Map<String, String> getUserHeader() {
    var credentials = base64.encode(utf8.encode(
        "${_authCredential.getMail()}:${_authCredential.getPassword()}"));
    return {
      "content-type": "application/json",
      "accept": "application/json",
      "authorization": "Basic $credentials"
    };
  }

  Map<String, String> getSudoHeader() {
    var credentials = base64.encode(utf8.encode("$aMail:$aPsw"));
    return {
      "content-type": "application/json",
      "accept": "application/json",
      "authorization": "Basic $credentials"
    };
  }
}
