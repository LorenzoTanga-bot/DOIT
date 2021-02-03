import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/User.dart';

abstract class AuthCredentialService {
  Future<User> loginWithCredentials(AuthCredential authCredential);
  Future<bool> updateCredentials(AuthCredential authCredential);
  Future<User> addUser(User newUser, AuthCredential authCredential);
  Future<bool> deleteCredential(AuthCredential authCredential);
  Future<User> updateUser(User newUser);
}
