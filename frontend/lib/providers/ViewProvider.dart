import 'package:doit/view/ListAllProjects.dart';
import 'package:doit/view/ListOfProjects.dart';
import 'package:doit/view/Login.dart';
import 'package:doit/view/ProfileDoubleRoleOverView.dart';
import 'package:doit/view/projectproposer/CreateModifyProject.dart';
import 'package:doit/view/ProfileUserOverView.dart';
import 'package:flutter/material.dart';

class ViewProvider with ChangeNotifier {
  int _selectedItemPosition = 0;
  List<Widget> _listViewPosition;

  Widget _firstDefault = ListAllProjects();
  Widget _secondDefault =
      ProfileDoubleRoleOverView(id: "be2a3756-819e-4266-89f0-2d78514b820a");
  Widget _threeDefault = Login();

  List<Widget> _listFirstPosition = [];
  List<Widget> _listSecondPosition = [];
  List<Widget> _listThreePosition = [];

  ViewProvider() {
    _listViewPosition = [_firstDefault, _secondDefault, _threeDefault];
  }

  List<Widget> getViewPosition() {
    return _listViewPosition;
  }

  int getSelectedItemPosition() {
    return _selectedItemPosition;
  }

  void setSelectedItemPosition(int index) {
    _selectedItemPosition = index;
  }

  void setProfileDefault(Widget widget) {
    _threeDefault = widget;
    _listViewPosition.removeAt(2);
    _listViewPosition.insert(2, widget);
    notifyListeners();
  }

  void dropFirstWidget() {
    _listFirstPosition.clear();
    _listViewPosition.removeAt(0);
    _listViewPosition.insert(0, _firstDefault);
    notifyListeners();
  }

  void dropSecondWidget() {
    _listSecondPosition.clear();
    _listViewPosition.removeAt(1);
    _listViewPosition.insert(1, _secondDefault);
    notifyListeners();
  }

  void pushWidget(Widget widget) {
    switch (_selectedItemPosition) {
      case 0:
        _listFirstPosition.add(widget);
        break;
      case 1:
        _listSecondPosition.add(widget);
        break;
      case 2:
        _listThreePosition.add(widget);
        break;
    }
    _listViewPosition.removeAt(_selectedItemPosition);
    _listViewPosition.insert(_selectedItemPosition, widget);
    notifyListeners();
  }

  void popWidget() {
    _listViewPosition.removeAt(_selectedItemPosition);
    switch (_selectedItemPosition) {
      case 0:
        _listFirstPosition.removeLast();
        _listViewPosition.insert(
            _selectedItemPosition,
            _listFirstPosition.isEmpty
                ? _firstDefault
                : _listFirstPosition.last);
        break;
      case 1:
        _listSecondPosition.removeLast();
        _listViewPosition.insert(
            _selectedItemPosition,
            _listSecondPosition.isEmpty
                ? _secondDefault
                : _listSecondPosition.last);
        break;
      case 2:
        _listThreePosition.removeLast();
        _listViewPosition.insert(
            _selectedItemPosition,
            _listThreePosition.isEmpty
                ? _threeDefault
                : _listThreePosition.last);
        break;
    }
    notifyListeners();
  }

  void dropThreeWidget() {
    _listThreePosition.clear();
    _listViewPosition.removeAt(2);
    _listViewPosition.insert(2, _threeDefault);
    notifyListeners();
  }
}
