import 'package:doit/model/AuthCredential.dart';

class User {
  String _id;
  bool _isAPerson;
  String _username;
  String _name;
  String _surname;
  String _mail;
  List<UserRole> _roles = [];
  List<String> _tags = [];
  List<String> _projects = [];

  User();

  User.firstAccess(String id, String mail) {
    _id = id;
    _mail = mail;
    _roles.add(UserRole.NOT_COMPLETED);
  }

  User.complete(
      String id,
      bool isAPerson,
      String username,
      String name,
      String surname,
      String mail,
      List<String> skills,
      List<UserRole> roles,
      List<String> projects) {
    _id = id;
    _isAPerson = isAPerson;
    _username = username;
    _name = name;
    _surname = surname;
    _mail = mail;
    _roles = roles;
    _tags = skills;
    _projects = this._projects;
  }

  String getId() {
    return _id;
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

  bool setMail(String mail) {
    _mail = mail;
    return true;
  }

  String getMail() {
    return _mail;
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

  bool setProjects(List<String> projects) {
    _projects = projects;
    return true;
  }

  bool addProject(String project) {
    _projects.add(project);
    return true;
  }

  List<String> getProjects() {
    return _projects;
  }

  bool getIsAperson() {
    return _isAPerson;
  }

  bool setIsAPerson(bool isAPerson) {
    _isAPerson = isAPerson;
    return true;
  }
}
