import 'package:doit/model/User.dart';
import 'package:doit/services/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  UserService _service;

  User _user;
  bool _isFirstAccess = false;
  List<User> _listUsers = [];

  UserProvider(UserService service) {
    _service = service;
  }

  User getSpringUser() {
    return _user;
  }

  bool isFirstAccess() {
    return _isFirstAccess;
  }

  Future<FirebaseUser> getUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  Future<String> getUserMail() async {
    FirebaseUser user = await getUser();
    if (user == null) {
      return 'null';
    } else {
      return user.email;
    }
  }

  Future updateUser(User user) async {
    _user = await _service.updateUser(user);
  }

  Future authSpringUser() async {
    _user = await _service.findByMail(await getUserMail());
    notifyListeners();
  }

  Future authMailPassword(String mail, String pass) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: mail, password: pass);
  }

  Future newSpringUser() async {
    _user =
        await _service.addUser(new User.firstAccess("", await getUserMail()));
    notifyListeners();
  }

  Future newMailPassword(String mail, String pass) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: mail,
      password: pass,
    );
    _isFirstAccess = true;
  }

  Future recoverPassword(String currentEmail) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: currentEmail,
    );
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
  }

  User findUserById(String id) {
    if (_user != null && _user.getId() == id) return _user;
    User user = _listUsers.where((user) => user.getId() == id).first;
    return user;
  }

  Future updateListUsers(List<String> id) async {
    for (String element in id) {
      if (_listUsers.where((tag) => tag.getId() == element).isEmpty)
        _listUsers.add(await _service.findById(element));
    }
    notifyListeners();
  }

  List<User> findUsersById(List<String> id) {
    List<User> users = [];
    for (String id in id) {
      if (_listUsers.where((user) => user.getId() == id).toList().isNotEmpty)
        users.add(_listUsers.where((user) => user.getId() == id).first);
    
    }
    return users;
  }
}
