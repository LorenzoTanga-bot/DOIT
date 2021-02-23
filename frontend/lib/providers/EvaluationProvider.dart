import 'package:doit/model/Evaluation.dart';
import 'package:doit/services/EvaluationService.dart';
import 'package:flutter/material.dart';

class EvaluationProvider with ChangeNotifier {
  EvaluationService _service;
  List<Evaluation> _listEvaluations = [];

  EvaluationProvider(EvaluationService service) {
    _service = service;
  }

  Future<Evaluation> addEvaluation(Evaluation evaluation) async {
    Evaluation newEvaluation = await _service.addEvaluation(evaluation);
    _listEvaluations.add(newEvaluation);
    return newEvaluation;
  }

  Future<Evaluation> updateEvaluation(Evaluation evaluation) async {
    Evaluation updateEvaluation = await _service.updateEvaluation(evaluation);
    _listEvaluations
        .removeWhere((element) => element.getId() == updateEvaluation.getId());
    _listEvaluations.add(updateEvaluation);
    notifyListeners();
    return updateEvaluation;
  }

  Future<List<Evaluation>> findBySender(String sender) async {
    List<Evaluation> found = await _service.findBySender(sender);
    updateListEvaluationsLocal(found);
    return found;
  }

  Future<List<Evaluation>> findByProject(String project) async {
    List<Evaluation> found = await _service.findByProject(project);
    updateListEvaluationsLocal(found);
    return found;
  }

  Future updateListEvaluation(List<String> ids) async {
    List<String> notFound = [];
    for (String id in ids) {
      if (_listEvaluations.where((element) => element.getId() == id).isEmpty)
        notFound.add(id);
    }
    if (notFound.isNotEmpty)
      _listEvaluations.addAll(await _service.findByIds(notFound));
    notifyListeners();
  }

  void updateListEvaluationsLocal(List<Evaluation> evaluations) {
    for (Evaluation evaluation in evaluations) {
      if (_listEvaluations
          .where((element) => element.getId() == evaluation.getId())
          .isEmpty) {
        _listEvaluations.add(evaluation);
      }
    }
    notifyListeners();
  }

  Evaluation findById(String id) {
    return _listEvaluations.firstWhere((element) => element.getId() == id);
  }

  List<Evaluation> findByIds(List<String> ids) {
    List<Evaluation> found = [];
    for (String id in ids) {
      found.add(findById(id));
    }
    return found;
  }
}
