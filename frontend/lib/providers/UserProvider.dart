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
  
  User findUserByMail(String mail) {
    return _listUsers.firstWhere((user) => user.getMail() == mail);
  }

  Future updateListUsers(List<String> mails) async {
    List<String> mailsNotFount = [];
    for (String mail in mails)
      if (_listUsers.where((user) => user.getMail() == mail).isEmpty)
        mailsNotFount.add(mail);

    _listUsers.addAll(await _service.findByMails(mailsNotFount));
    notifyListeners();
  }

  Future<List<User>> findByUsername(String username, String role) async {
    List<User> find = await _service.findByUsername(username, role);
    return find;
  }
}
