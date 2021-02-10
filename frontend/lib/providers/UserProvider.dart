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
    User user = _listUsers.firstWhere((user) => user.getMail() == mail);
    if (user == null) {
      user = await _service.findByMail(mail);
      _listUsers.add(user);
    }
    return user;
  }

  Future updateListUsers(List<String> id) async {
    List<String> mailsNotFount = [];
    for (String element in id)
      if (_listUsers.where((tag) => tag.getMail() == element).isEmpty)
        mailsNotFount.add(element);
    _listUsers.addAll(await _service.findByMails(mailsNotFount));
    notifyListeners();
  }

  Future<List<User>> findByUsername(String username, String role) async {
    List<User> find = await _service.findByUsername(username, role);
    return find;
  }
}
