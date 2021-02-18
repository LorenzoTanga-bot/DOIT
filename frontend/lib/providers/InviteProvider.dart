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

  Future<Invite> updateInvite(Invite invite) async {
    return await _service.updateInvite(invite);
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
}
