import 'package:doit/model/AuthCredential.dart';

class User {
  String _id;
  String _username;
  String _name;
  String _surname;
  String _mail;
  List<UserRole> _roles = [];
  List<String> _skills = [];
  List<String> _projects = [];

  User();

  User.firstAccess(String id, String mail) {
    _id = id;
    _mail = mail;
    _roles.add(UserRole.NOT_COMPLETED);
  }

  User.complete(
      String id,
      String username,
      String name,
      String surname,
      String mail,
      List<String> skills,
      List<UserRole> roles,
      List<String> projects) {
    _id = id;
    _username = username;
    _name = name;
    _surname = surname;
    _mail = mail;
    _roles = roles;
    _skills = skills;
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

  bool setSkills(List<String> skills) {
    _skills = skills;
    return true;
  }

  List<String> getSkills() {
    return _skills;
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
}
