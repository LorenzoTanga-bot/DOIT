import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/model/Invite.dart';
import 'package:http/http.dart' as http;

class InviteApiController {
  String _ip;
  String _baseUrl;

  InviteApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/invite";
  }

  String _stateToString(StateInvite state) {
    return state.toString().substring(state.toString().indexOf('.') + 1);
  }

  Future<String> addInvite(Invite invite) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/new"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              'id': invite.getId(),
              'sender': invite.getSender(),
              'designer': invite.getDesigner(),
              'projectProposer': invite.getProjectProposer(),
              'project': invite.getProject(),
              'dateOfInvite': invite.getDateOfInvite(),
              'stateProjectProposer':
                  _stateToString(invite.getStateProjectProposer()),
              'stateDesigner': _stateToString(invite.getStateDesigner()),
              'dateOfExpire': invite.getDateOfExpire(),
              'message': invite.getMessage()
            })))
        .body;
  }

  Future<String> updateStateDesigner(Invite invite) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/updateStateDesigner"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              'id': invite.getId(),
              'sender': invite.getSender(),
              'designer': invite.getDesigner(),
              'projectProposer': invite.getProjectProposer(),
              'project': invite.getProject(),
              'dateOfInvite': invite.getDateOfInvite(),
              'stateProjectProposer':
                  _stateToString(invite.getStateProjectProposer()),
              'stateDesigner': _stateToString(invite.getStateDesigner()),
              'dateOfExpire': invite.getDateOfExpire(),
              'message': invite.getMessage()
            })))
        .body;
  }

  Future<String> updateStateProjectProposer(Invite invite) async {
    return (await http.put(
            Uri.encodeFull("$_baseUrl/updateStateProjectProposer"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              'id': invite.getId(),
              'sender': invite.getSender(),
              'designer': invite.getDesigner(),
              'projectProposer': invite.getProjectProposer(),
              'project': invite.getProject(),
              'dateOfInvite': invite.getDateOfInvite(),
              'stateProjectProposer':
                  _stateToString(invite.getStateProjectProposer()),
              'stateDesigner': _stateToString(invite.getStateDesigner()),
              'dateOfExpire': invite.getDateOfExpire(),
              'message': invite.getMessage()
            })))
        .body;
  }

  Future<String> getInviteById(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getById/$id"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getInvitesByIds(List<String> ids) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/getByIds"),
            headers: BasicAuthConfig().getBaseHeader(), body: json.encode(ids)))
        .body;
  }

  Future<String> getInvitesByDesigner(String user) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByDesigner/$user"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getInvitesByProjectProposer(String user) async {
    return (await http.get(
            Uri.encodeFull("$_baseUrl/getByProjectProposer/$user"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getInvitesByProject(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByProject/$id"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }
    Future<String> getInvitesBySender(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getBySender/$id"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }
}
