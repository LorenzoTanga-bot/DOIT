import 'dart:convert';

import 'package:doit/apicontroller/CandidacyApiController.dart';
import 'package:doit/model/Candidacy.dart';
import 'package:doit/services/CandidacyService.dart';

class BackendCandidacyService implements CandidacyService {
  CandidacyApiController _controller;

  BackendCandidacyService(String ip) {
    _controller = new CandidacyApiController(ip);
  }

  List<Candidacy> _createListCandiacy(String controllerJson) {
    if (controllerJson == "") return null;
    var listCandidacy = json.decode(controllerJson);
    List<Candidacy> candidacies = new List<Candidacy>();
    for (var candidacy in listCandidacy) {
      candidacies.add(_newCandidacy(candidacy));
    }
    return candidacies;
  }

  Candidacy _newCandidacy(var candidacy) {
    return new Candidacy.complete(
        candidacy["id"],
        candidacy["designer"],
        candidacy["projectProposer"],
        candidacy["project"],
        candidacy["dateOfCandidacy"],
        StateCandidacy.values.firstWhere(
            (e) => e.toString() == 'StateCandidacy.' + candidacy["state"]),
        candidacy["dateOfOutcome"],
        candidacy["message"]);
  }

  Candidacy _createCandiacy(String controllerJson) {
    if (controllerJson == "") return null;
    return _newCandidacy(json.decode(controllerJson));
  }

  @override
  Future<Candidacy> addCandidacy(Candidacy candidacy) async {
    return _createCandiacy(await _controller.addCandidacy(candidacy));
  }

  @override
  Future<List<Candidacy>> findByDesigner(String designer) async {
    return _createListCandiacy(
        await _controller.getCandidaciesByDesigner(designer));
  }

  @override
  Future<Candidacy> findById(String id) async {
    return _createCandiacy(await _controller.getCandidacyById(id));
  }

  @override
  Future<List<Candidacy>> findByIds(List<String> ids) async {
    return _createListCandiacy(await _controller.getCandidaciesByIds(ids));
  }

  @override
  Future<List<Candidacy>> findByProject(String project) async {
    return _createListCandiacy(
        await _controller.getCandidaciesByProject(project));
  }

  @override
  Future<List<Candidacy>> findByProjectProposer(String projectProposer) async {
    return _createListCandiacy(
        await _controller.getCandidaciesByProjectProposer(projectProposer));
  }

  @override
  Future<Candidacy> updateCandidacy(Candidacy candidacy) async {
    return _createCandiacy(await _controller.updateCandidacy(candidacy));
  }
}
