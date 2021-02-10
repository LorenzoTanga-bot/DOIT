import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  bool searchProject = true;
  bool searchUser = true;
  bool searchDesigner = true;
  bool searchProjectProposer = true;

  bool getSearchProject() {
    return searchProject;
  }

  bool setSearchProject(bool newValue) {
    searchProject = newValue;
    notifyListeners();
    return true;
  }

  bool getSearchUser() {
    return searchUser;
  }

  bool setSearchUser(bool newValue) {
    searchUser = newValue;
    notifyListeners();
    return true;
  }

  bool getSearchDesigner() {
    return searchDesigner;
  }

  bool setSearchDesigner(bool newValue) {
    searchDesigner = newValue;
    notifyListeners();
    return true;
  }

  bool getSearchProjectProposer() {
    return searchProjectProposer;
  }

  bool setSearchProjectProposer(bool newValue) {
    searchProjectProposer = newValue;
    notifyListeners();
    return true;
  }
}
