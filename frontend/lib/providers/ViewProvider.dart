import 'package:doit/view/ListAllProjects.dart';
import 'package:doit/view/Login.dart';
import 'package:doit/view/SearchPage.dart';
import 'package:doit/widget/FutureBuilder.dart';

import 'package:flutter/material.dart';

class ViewProvider with ChangeNotifier {
  int _selectedItemPosition = 0;
  List<Widget> _listViewPosition;

  Widget _firstDefault = ListAllProjects();
  Widget _secondDefault = SearchPage();
  Widget _thirdDefault = Login();

  List<Widget> _listFirstPosition = [];
  List<Widget> _listSecondPosition = [];
  List<Widget> _listThirdPosition = [];

  ViewProvider() {
    _listViewPosition = [_firstDefault, _secondDefault, _thirdDefault];
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
    _thirdDefault = widget;
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

  void dropThirdWidget() {
    _listThirdPosition.clear();
    _listViewPosition.removeAt(2);
    _listViewPosition.insert(2, _thirdDefault);
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
        _listThirdPosition.add(widget);
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
        if (_listFirstPosition.isNotEmpty) _listFirstPosition.removeLast();
        if (_listFirstPosition.isNotEmpty &&
            _listFirstPosition.last is FutureBuild)
          _listFirstPosition.removeLast();
        _listViewPosition.insert(
            _selectedItemPosition,
            _listFirstPosition.isEmpty
                ? _firstDefault
                : _listFirstPosition.last);
        break;
      case 1:
        if (_listSecondPosition.isNotEmpty) _listSecondPosition.removeLast();
        if (_listSecondPosition.isNotEmpty &&
            _listSecondPosition.last is FutureBuild)
          _listSecondPosition.removeLast();
        _listViewPosition.insert(
            _selectedItemPosition,
            _listSecondPosition.isEmpty
                ? _secondDefault
                : _listSecondPosition.last);
        break;
      case 2:
        if (_listThirdPosition.isNotEmpty) _listThirdPosition.removeLast();
        if (_listThirdPosition.isNotEmpty &&
            _listThirdPosition.last is FutureBuild)
          _listThirdPosition.removeLast();
        _listViewPosition.insert(
            _selectedItemPosition,
            _listThirdPosition.isEmpty
                ? _thirdDefault
                : _listThirdPosition.last);
        break;
    }
    notifyListeners();
  }
}
