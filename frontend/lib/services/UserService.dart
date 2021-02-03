import 'package:doit/model/User.dart';

abstract class UserService {
  Future<User> addUser(User newUser);
  Future<User> updateUser(User newUser);
  Future<User> findById(String id);
  Future<User> findByMail(String mail);
  Future<List<User>> findByUsername(String username, UserRole role);
  Future<List<User>> findByTags(List<String> tags, UserRole role);
  Future<bool> existByMail(String mail);
}
