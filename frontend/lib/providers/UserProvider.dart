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
    if (_listUsers.isEmpty) _listUsers.add(await _service.findByMail(mail));
    for (User user in _listUsers) {
      if (user.getMail() == mail) {
        return user;
      }
    }
    List<String> notFound = [];
    notFound.add(mail);
    updateListUsers(notFound);
    return findUserByMail(mail);
  }

  Future updateListUsers(List<String> mails) async {
    List<String> mailsNotFount = [];
    for (String mail in mails) {
      for (User user in _listUsers) {
        if (user.getMail() == mail) {
          break;
        }
        mailsNotFount.add(mail);
      }
    }
    _listUsers.addAll(await _service.findByMails(mailsNotFount));
    notifyListeners();
  }

  Future<List<User>> findByUsername(String username, String role) async {
    List<User> find = await _service.findByUsername(username, role);
    return find;
  }
}
