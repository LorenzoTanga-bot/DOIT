import 'package:doit/model/User.dart';

abstract class UserService {
  Future<User> findById(String id);
  Future<User> findByMail(String mail);
  Future<User> findByUsername(String username);
  Future<List<User>> findBySkills(List<String> skills);
}
