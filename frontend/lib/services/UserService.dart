import 'package:doit/model/User.dart';

abstract class UserService {
  Future<List<User>> findByMails(List<String> mails);
  Future<User> findByMail(String mail);
  Future<List<User>> findByUsername(String username, String role);
  Future<List<User>> findByTags(List<String> skills);
}
