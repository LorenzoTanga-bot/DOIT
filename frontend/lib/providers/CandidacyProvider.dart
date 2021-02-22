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
    Candidacy newCandidacy = await _service.addCandidacy(candidacy);
    _listCandidacies.add(newCandidacy);
    return newCandidacy;
  }

  Future<Candidacy> updateCandidacy(Candidacy candidacy) async {
    Candidacy modifiedCandidacy = await _service.updateCandidacy(candidacy);
    _listCandidacies
        .removeWhere((element) => element.getId() == modifiedCandidacy.getId());
    _listCandidacies.add(modifiedCandidacy);

    return modifiedCandidacy;
  }

  Future<List<Candidacy>> findByDesigner(String designer) async {
    List<Candidacy> candidacies = await _service.findByDesigner(designer);
    updateListCandidaciesLocal(candidacies);
    return candidacies;
  }

  Future<List<Candidacy>> findByProjectProposer(String projectProposer) async {
    List<Candidacy> candidacies =
        await _service.findByProjectProposer(projectProposer);
    updateListCandidaciesLocal(candidacies);
    return candidacies;
  }

  Future<List<Candidacy>> findByProject(String project) async {
    List<Candidacy> candidacies = await _service.findByProject(project);
    updateListCandidaciesLocal(candidacies);
    return candidacies;
  }

  void updateListCandidaciesLocal(List<Candidacy> candidacies) {
    for (Candidacy candidacy in candidacies) {
      if (_listCandidacies
          .where((element) => element.getId() == candidacy.getId())
          .isEmpty) {
        _listCandidacies.add(candidacy);
      }
    }
    notifyListeners();
  }

  Future updateListCandidacies(List<String> ids) async {
    List<String> notFound = [];
    for (String id in ids) {
      if (_listCandidacies.where((element) => element.getId() == id).isEmpty)
        notFound.add(id);
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
