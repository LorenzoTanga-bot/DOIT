import 'package:doit/model/User.dart';
import 'package:doit/services/UserService.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  UserService _service;

  List<User> _listUsers = [];

  UserProvider(UserService service) {
    _service = service;
  }

  Future recoverPassword(String currentEmail) async {
    //TODO da fare
  }

  Future<User> findUserByMail(String mail) async {
    List<String> find = [];
    find.add(mail);
    if (_listUsers.isEmpty) await updateListUsers(find);
    for (User user in _listUsers) {
      if (user.getMail() == mail) {
        return user;
      }
    }
    await updateListUsers(find);
    return findUserByMail(mail);
  }

  Future updateListUsers(List<String> mails) async {
    List<String> mailsNotFount = [];
    for (String mail in mails) {
      if (!_listUsers.contains(mail)) mailsNotFount.add(mail);
    }
    _listUsers.addAll(await _service.findByMails(mailsNotFount));
    notifyListeners();
  }

  Future<List<User>> findByUsername(String username, String role) async {
    List<User> find = await _service.findByUsername(username, role);
    return find;
  }

  void updateUser(User user) {
    User oldUser = _listUsers.firstWhere((p) => p.getMail() == user.getMail());
    _listUsers.remove(oldUser);
    _listUsers.add(user);
  }

  Future<List<User>> findByTags(List<String> tags, String role) async {
    List<User> find = await _service.findByTags(tags, role);
    return find;
  }
}
