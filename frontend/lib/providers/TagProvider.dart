import 'package:doit/model/Tag.dart';
import 'package:doit/services/TagService.dart';
import 'package:flutter/foundation.dart';

class TagProvider with ChangeNotifier {
  TagService _service;
  List<Tag> _listTag = [];
  List<String> _selectedTagForProject = List<String>();
  List<String> _selectedTagForSearch = List<String>();
  List<String> _selectedTagForSignin = List<String>();
  TagProvider(TagService service) {
    _service = service;
  }

  List<Tag> getListTag() {
    return _listTag;
  }

  Future updateListAllTag() async {
    _listTag = await _service.findAll();
    notifyListeners();
  }

  Future updateListTag(List<String> tagid) async {
    List<String> tagNotFount = [];
    for (String id in tagid)
      if (_listTag.where((tag) => tag.getId() == id).isEmpty)
        tagNotFount.add(id);

    _listTag.addAll(await _service.findByIds(tagNotFount));
    notifyListeners();
  }

  Future<bool> addListTag(Tag newTag, String index) async {
    newTag = await _service.addTag(newTag);
    _listTag.add(newTag);
    switch (index) {
      case "PROJECT":
        _selectedTagForProject.add(newTag.getId());
        notifyListeners();
        return true;
      case "SEARCH":
        _selectedTagForSearch.add(newTag.getId());
        notifyListeners();
        return true;
      case "SIGNIN":
        _selectedTagForSignin.add(newTag.getId());
        notifyListeners();
        return true;
      default:
        return null;
    }
  }

  List<String> getSelectTag(String index) {
    switch (index) {
      case "PROJECT":
        return _selectedTagForProject;
      case "SEARCH":
        return _selectedTagForSearch;
      case "SIGNIN":
        return _selectedTagForSignin;
      default:
        return null;
    }
  }

  bool addSelectedTag(String newTag, String index) {
    switch (index) {
      case "PROJECT":
        _selectedTagForProject.add(newTag);
        return true;
      case "SEARCH":
        _selectedTagForSearch.add(newTag);
        return true;
      case "SIGNIN":
        _selectedTagForSignin.add(newTag);
        return true;
      default:
        return false;
    }
  }

  bool setSelectTag(List<String> selectedTag, String index) {
    switch (index) {
      case "PROJECT":
        _selectedTagForProject = selectedTag;
        return true;
      case "SEARCH":
        _selectedTagForSearch = selectedTag;
        return true;
      case "SIGNIN":
        _selectedTagForSignin = selectedTag;
        return true;
      default:
        return false;
    }
  }

  bool clearSelectedTag(String index) {
    switch (index) {
      case "PROJECT":
        _selectedTagForProject.clear();
        return true;
      case "SEARCH":
        _selectedTagForSearch.clear();
        return true;
      case "SIGNIN":
        _selectedTagForSignin.clear();
        return true;
      default:
        return false;
    }
  }

  List<Map<String, String>> getListMapTag() {
    List<Map<String, String>> _allTagsMap = new List<Map<String, String>>();
    for (Tag tag in _listTag) _allTagsMap.add(tag.toMap());
    return _allTagsMap;
  }

  List<Tag> getTagsByIds(List<String> listId) {
    List<Tag> returnTag = [];
    int i = 0;
    do {
      for (String id in listId) {
        if (_listTag.where((tag) => tag.getId() == id).toList().isNotEmpty) {
          returnTag.add(_listTag.where((tag) => tag.getId() == id).first);
          i = i + 1;
        } else
          updateListAllTag();
      }
    } while (listId.length != i);

    return returnTag;
  }
}
