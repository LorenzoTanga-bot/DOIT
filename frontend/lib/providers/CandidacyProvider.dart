import 'package:doit/model/Candidacy.dart';
import 'package:doit/services/CandidacyService.dart';
import 'package:flutter/material.dart';

class CandidacyProvider with ChangeNotifier {
  CandidacyService _service;
  List<Candidacy> _listCandidacies = [];

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
 Future updateListCandidacies(List<String> ids) async {
    List<String> notFound = [];
    for (String id in ids) {
      if (_listCandidacies
          .where((element) => element.getId() == id)
          .isEmpty) notFound.add(id);
    }
    if (notFound.isNotEmpty)
      _listCandidacies.addAll(await _service.findByIds(notFound));
    notifyListeners();
  }

  Candidacy findById(String id) {
    return _listCandidacies.firstWhere((element) => element.getId() == id);
  }

  List<Candidacy> findByIds(List<String> ids) {
    List<Candidacy> found = [];
    for (String id in ids) {
      found.add(findById(id));
    }
    return found;
  }

}
