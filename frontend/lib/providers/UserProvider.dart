import 'package:doit/model/User.dart';
import 'package:doit/services/UserService.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  UserService _service;

  List<User> _listUsers = [];

  UserProvider(UserService service) {
    _service = service;
  }
// da cambiare
  Future recoverPassword(String currentEmail) async {
    // await FirebaseAuth.instance.sendPasswordResetEmail(
    //  email: currentEmail,
    //);
  }
  Future<User> findUserById(String id) async {
    if (_listUsers.isEmpty) _listUsers.add(await _service.findById(id));
    User user = _listUsers.firstWhere((user) => user.getId() == id);
    if (user == null) {
      user = await _service.findById(id);
      _listUsers.add(user);
    }
    return user;
  }

  Future updateListUsers(List<String> id) async {
    List<String> idNotFount = [];
    for (String element in id)
      if (_listUsers.where((tag) => tag.getId() == element).isEmpty)
        idNotFount.add(element);
    _listUsers.addAll(await _service.findByIds(idNotFount));
    notifyListeners();
  }

  Future<List<User>> findByUsername(String username, String role) async {
    List<User> find = await _service.findByUsername(username, role);
    return find;
  }
}
