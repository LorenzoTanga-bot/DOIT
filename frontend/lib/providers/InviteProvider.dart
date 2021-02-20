import 'package:doit/model/Invite.dart';
import 'package:doit/services/InviteService.dart';
import 'package:flutter/material.dart';

class InviteProvider with ChangeNotifier {
  InviteService _service;
  List<Invite> _listInvite = [];

  InviteProvider(InviteService service) {
    _service = service;
  }

  Future<Invite> addInvite(Invite invite) async {
    return await _service.addInvite(invite);
  }

  Future<Invite> updateStateDesigner(Invite invite) async {
    return await _service.updateStateDesigner(invite);
  }
  Future<Invite> updateStateProjectProposer(Invite invite) async {
    return await _service.updateStateProjectProposer(invite);
  }

  Future<List<Invite>> findByDesigner(String designer) async {
    return await _service.findByDesigner(designer);
  }

  Future<List<Invite>> findByProjectProposer(String projectProposer) async {
    return await _service.findByProjectProposer(projectProposer);
  }

  Future<List<Invite>> findByProject(String project) async {
    return await _service.findByProject(project);
  }
 Future updateListInvites(List<String> ids) async {
    List<String> notFound = [];
    for (String id in ids) {
      if (_listInvite 
          .where((element) => element.getId() == id)
          .isEmpty) notFound.add(id);
    }
    if (notFound.isNotEmpty)
      _listInvite .addAll(await _service.findByIds(notFound));
    notifyListeners();
  }

  Invite findById(String id) {
    return _listInvite .firstWhere((element) => element.getId() == id);
  }

  List<Invite> findByIds(List<String> ids) {
    List<Invite> found = [];
    for (String id in ids) {
      found.add(findById(id));
    }
    return found;
  }

}
