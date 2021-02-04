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
    List<String> find = [];
    find.add(id);
    if (_listUsers.isEmpty) await updateListUsers(find);
    User user = _listUsers.where((user) => user.getId() == id).first;

    return user;
  }

  Future updateListUsers(List<String> id) async {
    for (String element in id)
      if (_listUsers.where((tag) => tag.getId() == element).isEmpty)
        _listUsers.add(await _service.findById(element));

    notifyListeners();
  }
}
