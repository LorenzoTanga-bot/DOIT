import 'package:doit/model/Candidacy.dart';
import 'package:doit/services/CandidacyService.dart';
import 'package:flutter/material.dart';

class CandidacyProvider with ChangeNotifier {
  CandidacyService _service;
  List<Candidacy> _listCandidacy = [];

  CandidacyProvider(CandidacyService service) {
    _service = service;
  }

  Future<Candidacy> addCandidacy(Candidacy candidacy) async {
    return await _service.addCandidacy(candidacy);
  }

  Future<Candidacy> updateCandidacy(Candidacy candidacy) async {
    return await _service.updateCandidacy(candidacy);
  }

  Future<List<Candidacy>> findByDesigner(String designer) async {
    return await _service.findByDesigner(designer);
  }

  Future<List<Candidacy>> findByProjectProposer(String projectProposer) async {
    return await _service.findByProjectProposer(projectProposer);
  }

  Future<List<Candidacy>> findByProject(String project) async {
    return await _service.findByProject(project);
  }
}
