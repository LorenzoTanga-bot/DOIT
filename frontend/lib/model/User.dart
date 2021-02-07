import 'dart:convert';

import 'package:doit/model/AuthCredential.dart';

class User {
  String _id;
  bool _isAPerson = false;
  String _username = "";
  String _name = "";
  String _surname = "";
  String _mail;
  List<UserRole> _roles = [];
  List<String> _tags = [];
  List<String> _projectsFirstRole = [];
  List<String> _projectsSecondRole = [];

  User();

  User.firstAccess(String id, String mail) {
    _id = id;
    _mail = mail;
    _roles.add(UserRole.NOT_COMPLETED);
  }

  User.fromJson(
      String id,
      bool isAPerson,
      String username,
      String name,
      String surname,
      String mail,
      List<String> tags,
      List<UserRole> roles,
      List<String> projectsFirstRole,
      List<String> projectsSecondRole) {
    User.complete(id, isAPerson, username, name, surname, mail, tags, roles,
        projectsFirstRole, projectsSecondRole);
  }



  User.complete(
      String id,
      bool isAPerson,
      String username,
      String name,
      String surname,
      String mail,
      List<String> tags,
      List<UserRole> roles,
      List<String> projectsFirstRole,
      List<String> projectsSecondRole) {
    _id = id;
    _isAPerson = isAPerson;
    _username = username;
    _name = name;
    _surname = surname;
    _mail = mail;
    _roles = roles;
    _tags = tags;
    _projectsFirstRole = projectsFirstRole;
    _projectsSecondRole = projectsSecondRole;
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

  bool setProjectsFirstRole(List<String> projects) {
    _projectsFirstRole = projects;
    return true;
  }

  bool addProjectFirstRole(String project) {
    _projectsFirstRole.add(project);
    return true;
  }

  List<String> getProjectsFirstRole() {
    return _projectsFirstRole;
  }

  bool setProjectsSecondRole(List<String> projects) {
    _projectsSecondRole = projects;
    return true;
  }

  bool addProjectsSecondRole(String project) {
    _projectsSecondRole.add(project);
    return true;
  }

  List<String> getProjectsSecondRole() {
    return _projectsSecondRole;
  }

  bool getIsAperson() {
    return _isAPerson;
  }

  bool setIsAPerson(bool isAPerson) {
    _isAPerson = isAPerson;
    return true;
  }
}
