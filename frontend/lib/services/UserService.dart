import 'package:doit/model/User.dart';

abstract class UserService {
  Future<User> findByMail(String mail);
  Future<List<User>> findByMails(List<String> mails);
  Future<List<User>> findByTags(List<String> skills);
  Future<List<User>> findByUsername(String username, String role);
}
