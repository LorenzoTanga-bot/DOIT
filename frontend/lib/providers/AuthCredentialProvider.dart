import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/User.dart';
import 'package:doit/services/AuthCredentialService.dart';
import 'package:flutter/foundation.dart';

class AuthCredentialProvider with ChangeNotifier {
  AuthCredentialService _service;

  User _user;

  AuthCredentialProvider(AuthCredentialService service) {
    _service = service;
  }

  User getUser() {
    return _user;
  }

  Future loginWithCredentials(AuthCredential authCredential) async {
    _user = await _service.loginWithCredentials(authCredential);
    BasicAuthConfig().setAuthCredential(authCredential);
    notifyListeners();
  }

  Future newMailPassword(User newUser, AuthCredential authCredential) async {
    _user = await _service.addUser(newUser, authCredential);
    BasicAuthConfig().setAuthCredential(authCredential);
    notifyListeners();
  }

  logout() {
    _user = null;
    BasicAuthConfig().deleteAuthCredential();
    notifyListeners();
  }

  Future updateUser(User newUser) async {
    _user = await _service.updateUser(newUser);
  }
}
