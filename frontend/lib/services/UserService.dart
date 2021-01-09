import 'package:doit/model/User.dart';

abstract class UserService {
  Future<User> addUser(User newUser);
  Future<User> updateUser(User newUser);
  Future<User> findByMail(String mail);
  Future<User> findByUsername(String username);
  Future<List<User>> findBySkills(List<String> skills);
  Future<bool> existByMail(String mail);
}
