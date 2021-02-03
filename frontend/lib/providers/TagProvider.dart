import 'package:doit/model/Tag.dart';
import 'package:doit/services/TagService.dart';
import 'package:flutter/foundation.dart';

class TagProvider with ChangeNotifier {
  TagService _service;
  List<Tag> _listTag = [];
  List<String> _selectedTag = List<String>();

  TagProvider(TagService service) {
    _service = service;
  }

  List<Tag> getListTag() {
    return _listTag;
  }

  Future updateListTag() async {
    _listTag = await _service.findAll();
    notifyListeners();
  }

  Future<bool> addListTag(Tag newTag) async {
    newTag = await _service.addTag(newTag);
    _listTag.add(newTag);
    _selectedTag.add(newTag.getId());
    notifyListeners();
    return true;
  }

  List<String> getSelectTag() {
    return _selectedTag;
  }

  bool addSelectedTag(String newTag) {
    _selectedTag.add(newTag);
    return true;
  }

  bool setSelectTag(List<String> selectedTag) {
    _selectedTag = selectedTag;
    return true;
  }

  bool clearSelectedTag() {
    _selectedTag.clear();
    return true;
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
          updateListTag();
      }
    } while (listId.length != i);

    return returnTag;
  }
}
