import 'dart:convert';

import 'package:doit/apicontroller/InviteApiController.dart';
import 'package:doit/model/Invite.dart';
import 'package:doit/services/InviteService.dart';

class BackendInviteService implements InviteService {
  InviteApiController _controller;

  BackendInviteService(String ip) {
    _controller = new InviteApiController(ip);
  }

  List<Invite> _createListInvite(String controllerJson) {
    if (controllerJson == "") return null;
    var listInvites = json.decode(controllerJson);
    List<Invite> invites = [];
    for (var invite in listInvites) {
      invites.add(_newInvite(invite));
    }
    return invites;
  }

  Invite _newInvite(var invite) {
    return new Invite.complete(
        invite["id"],
        invite["sender"],
        invite["designer"],
        invite["projectProposer"],
        invite["project"],
        StateInvite.values.firstWhere((e) =>
            e.toString() == 'StateInvite.' + invite["stateProjectProposer"]),
        StateInvite.values.firstWhere(
            (e) => e.toString() == 'StateInvite.' + invite["stateDesigner"]),
        invite["dateOfInvite"],
        invite["dateOfExpire"],
        invite["message"]);
  }

  Invite _createInvite(String controllerJson) {
    if (controllerJson == "") return null;
    return _newInvite(json.decode(controllerJson));
  }

  @override
  Future<Invite> addInvite(Invite invite) async {
    return _createInvite(await _controller.addInvite(invite));
  }

  @override
  Future<List<Invite>> findByDesigner(String designer) async {
    return _createListInvite(await _controller.getInvitesByDesigner(designer));
  }

  @override
  Future<Invite> findById(String id) async {
    return _createInvite(await _controller.getInviteById(id));
  }

  @override
  Future<List<Invite>> findByIds(List<String> ids) async {
    return _createListInvite(await _controller.getInvitesByIds(ids));
  }

  @override
  Future<List<Invite>> findByProject(String project) async {
    return _createListInvite(await _controller.getInvitesByProject(project));
  }

  @override
  Future<List<Invite>> findByProjectProposer(String projectProposer) async {
    return _createListInvite(
        await _controller.getInvitesByProjectProposer(projectProposer));
  }

  @override
  Future<List<Invite>> findBySender(String sender) async {
    return _createListInvite(await _controller.getInvitesBySender(sender));
  }

  @override
  Future<Invite> updateStateDesigner(Invite invite) async {
    return _createInvite(await _controller.updateStateDesigner(invite));
  }

  @override
  Future<Invite> updateStateProjectProposer(Invite invite) async {
    return _createInvite(await _controller.updateStateProjectProposer(invite));
  }
}
