import 'dart:convert';

import 'package:doit/apicontroller/TagApiController.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/services/TagService.dart';

class BackendTagService implements TagService {
  TagApiController _controller;

  BackendTagService(String ip) {
    _controller = new TagApiController(ip);
  }

  Tag _newTag(var tag) {
    return new Tag.fromJson(tag["id"], tag["value"]);
  }

  Tag _createTag(String controllerJson) {
    if (controllerJson == "") return null;
    return _newTag(json.decode(controllerJson));
  }

  List<Tag> _createListTag(String controllerJson) {
    if (controllerJson == "") return null;
    var listTag = json.decode(controllerJson);
    List<Tag> tags = [];
    for (var tag in listTag) {
      tags.add(_newTag(tag));
    }
    return tags;
  }

  @override
  Future<Tag> addTag(Tag newTag) async {
    return _createTag(await _controller.addTag(newTag));
  }

  @override
  Future<List<Tag>> findAll() async {
    return _createListTag(await _controller.getAllTag());
  }

  @override
  Future<Tag> findById(String id) async {
    return _createTag(await _controller.getTagById(id));
  }

  @override
  Future<List<Tag>> findByIds(List<String> ids) async {
    return _createListTag(await _controller.getTagByIds(ids));
  }
}
