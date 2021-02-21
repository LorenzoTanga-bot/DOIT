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
    Invite newInvite = await _service.addInvite(invite);
    _listInvite.add(newInvite);
    return newInvite;
  }

// non funziona
  Future<Invite> updateStateDesigner(Invite invite) async {
    Invite updateInvite = await _service.updateStateDesigner(invite);
    _listInvite.remove(invite);
    _listInvite.add(updateInvite);
    return updateInvite;
  }

  Future<Invite> updateStateProjectProposer(Invite invite) async {
    Invite updateInvite = await _service.updateStateProjectProposer(invite);
    _listInvite.remove(invite);
    _listInvite.add(updateInvite);
    return updateInvite;
  }

  Future<List<Invite>> findByDesigner(String designer) async {
    List<Invite> found = await _service.findByDesigner(designer);
    List<String> invites = [];
    for (Invite invite in found) {
      invites.add(invite.getId());
    }
    updateListInvites(invites);
    return found;
  }

  Future<List<Invite>> findByProjectProposer(String projectProposer) async {
    List<Invite> found = await _service.findByProjectProposer(projectProposer);
    List<String> invites = [];
    for (Invite invite in found) {
      invites.add(invite.getId());
    }
    updateListInvites(invites);
    return found;
  }

  Future<List<Invite>> findByProject(String project) async {
    List<Invite> found = await _service.findByProject(project);
    List<String> invites = [];
    for (Invite invite in found) {
      invites.add(invite.getId());
    }
    updateListInvites(invites);
    return found;
  }

  Future updateListInvites(List<String> ids) async {
    List<String> notFound = [];
    for (String id in ids) {
      if (_listInvite.where((element) => element.getId() == id).isEmpty)
        notFound.add(id);
    }
    if (notFound.isNotEmpty)
      _listInvite.addAll(await _service.findByIds(notFound));
    notifyListeners();
  }

  Invite findById(String id) {
    return _listInvite.firstWhere((element) => element.getId() == id);
  }

  List<Invite> findByIds(List<String> ids) {
    List<Invite> found = [];
    for (String id in ids) {
      found.add(findById(id));
    }
    return found;
  }
}
