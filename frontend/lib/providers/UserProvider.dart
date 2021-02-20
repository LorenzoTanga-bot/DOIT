import 'dart:collection';

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
  Future updateListUsers(List<String> mails) async {
    List<String> notFound = [];
    for (String mail in mails) {
      if (_listUsers.where((element) => element.getMail() == mail).isEmpty)
        notFound.add(mail);
    }
    if (notFound.isNotEmpty)
      _listUsers.addAll(await _service.findByMails(notFound));
    notifyListeners();
  }

  User findByMail(String id) {
    return _listUsers.firstWhere((element) => element.getMail() == id);
  }

  List<User> findByMails(List<String> ids) {
    List<User> found = [];
    for (String id in ids) {
      found.add(findByMail(id));
    }
    return found;
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
