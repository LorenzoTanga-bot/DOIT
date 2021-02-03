import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/User.dart';

abstract class AuthCredentialService {
  Future<User> loginWithCredentials(AuthCredential authCredential);
  Future<bool> updateCredentials(AuthCredential authCredential);
  Future<User> addPerson(User newUser, AuthCredential authCredential);
  Future<bool> deleteCredential(AuthCredential authCredential);
}
