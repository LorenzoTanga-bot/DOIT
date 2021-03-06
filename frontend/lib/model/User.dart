import 'package:doit/model/AuthCredential.dart';

class User {
  String _mail;
  String _username;
  String _name;
  String _surname; //se è una azienda qui viene salvata la Paritta iva
  List<UserRole> _roles = [];
  List<String> _tags = [];


  User();

  User.firstAccess(String mail) {
    _mail = mail;
    _roles.add(UserRole.NOT_COMPLETED);
  }

  User.complete(
      this._mail,
      this._username,
      this._name,
      this._surname,
      this._roles,
      this._tags,
      );

  bool setMail(String mail) {
    _mail = mail;
    return true;
  }

  String getMail() {
    return _mail;
  }

  bool getIsAPerson() {
    if (_roles.contains(UserRole.DESIGNER_ENTITY) ||
        _roles.contains(UserRole.PROJECT_PROPOSER))
      return false;
    else
      return true;
  }

  bool setUsername(String username) {
    _username = username;
    return true;
  }

  String getUsername() {
    return _username;
  }

  bool setName(String name) {
    _name = name;
    return true;
  }

  String getName() {
    return _name;
  }

  bool setSurname(String surname) {
    _surname = surname;
    return true;
  }

  String getSurname() {
    return _surname;
  }

  bool setRoles(List<UserRole> roles) {
    _roles = roles;
    return true;
  }

  List<UserRole> getRoles() {
    return _roles;
  }

  bool setTags(List<String> tags) {
    _tags = tags;
    return true;
  }

  List<String> getTags() {
    return _tags;
  }

  
}
