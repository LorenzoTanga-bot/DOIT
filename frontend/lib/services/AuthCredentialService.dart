import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/User.dart';

abstract class AuthCredentialService {
  Future<User> loginWithCredentials(AuthCredential authCredential);
  Future<bool> addCredentials(AuthCredential authCredential);
  Future<bool> updateCredentials(AuthCredential authCredential);
  Future<User> addUser(User newUser);
  Future<User> updateUser(User newUser);
  Future<bool> deleteCredential(AuthCredential authCredential);
}
