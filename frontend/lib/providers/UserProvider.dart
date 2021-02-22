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
    List<User> finds = await _service.findByUsername(username, role);
    updateListUsersLocal(finds);
    return finds;
  }

  void updateListUsersLocal(List<User> users) {
    for (User user in users) {
      if (_listUsers
          .where((element) => element.getMail() == user.getMail())
          .isEmpty) {
        _listUsers.add(user);
      }
    }
    notifyListeners();
  }

  Future<List<User>> findByTags(List<String> tags, String role) async {
    List<User> finds = await _service.findByTags(tags, role);
    updateListUsersLocal(finds);
    return finds;
  }

  Future reloadUser(String mail) async {
    User reloadedUser = await _service.findByMail(mail);
    _listUsers
        .removeWhere((element) => element.getMail() == reloadedUser.getMail());
    _listUsers.add(reloadedUser);
    notifyListeners();
  }
}
