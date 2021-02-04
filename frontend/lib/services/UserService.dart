import 'package:doit/model/User.dart';

abstract class UserService {
  Future<User> findById(String id);
  Future<User> findByMail(String mail);
  Future<List<User>> findByUsername(String username,String role);
  Future<List<User>> findBySkills(List<String> skills);
}
