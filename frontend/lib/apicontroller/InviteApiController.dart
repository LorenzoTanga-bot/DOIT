import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/model/Invite.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class InviteApiController {
  String _ip;
  String _baseUrl;

  InviteApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/invite";
  }

  String _getBodyResponse(Response response) {
    if (response.statusCode == 200)
      return response.body;
    else {
      throw (json.decode(response.body)["message"]);
    }
  }

  String _stateToString(StateInvite state) {
    return state.toString().substring(state.toString().indexOf('.') + 1);
  }

  Future<String> addInvite(Invite invite) async {
    return _getBodyResponse(await http.post(Uri.encodeFull("$_baseUrl/new"),
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
        })));
  }

  Future<String> updateStateDesigner(Invite invite) async {
    return _getBodyResponse(
        await http.put(Uri.encodeFull("$_baseUrl/updateStateDesigner"),
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
            })));
  }

  Future<String> updateStateProjectProposer(Invite invite) async {
    return _getBodyResponse(
        await http.put(Uri.encodeFull("$_baseUrl/updateStateProjectProposer"),
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
            })));
  }

  Future<String> getInviteById(String id) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/getById/$id"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getInvitesByIds(List<String> ids) async {
    return _getBodyResponse(await http.put(Uri.encodeFull("$_baseUrl/getByIds"),
        headers: BasicAuthConfig().getBaseHeader(), body: json.encode(ids)));
  }

  Future<String> getInvitesByDesigner(String user) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/getByDesigner/$user"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getInvitesByProjectProposer(String user) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/getByProjectProposer/$user"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getInvitesByProject(String id) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/getByProject/$id"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getInvitesBySender(String id) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/getBySender/$id"),
        headers: BasicAuthConfig().getBaseHeader()));
  }
}
