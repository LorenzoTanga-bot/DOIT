import 'package:doit/model/Evaluation.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/services/EvaluationService.dart';
import 'package:flutter/material.dart';

class EvaluationProvider with ChangeNotifier {
  EvaluationService _service;
  List<Evaluation> _listEvaluations = [];

  EvaluationProvider(EvaluationService service) {
    _service = service;
  }
  bool alreadySended(
      String userId, EvaluationMode evaluationMode, String project) {
    for (Evaluation existingEvaluation in _listEvaluations) {
      if (existingEvaluation.getSender() == userId &&
          existingEvaluation.getEvaluationMode() == evaluationMode &&
          existingEvaluation.getProject() == project) return true;
    }
    return false;
  }

  Future<Evaluation> addEvaluation(Evaluation evaluation) async {
    Evaluation newEvaluation = await _service.addEvaluation(evaluation);
    _listEvaluations.add(newEvaluation);
    notifyListeners();
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

  List<Evaluation> findSendedEvaluation(String user) {
    List<Evaluation> found = [];
    for (Evaluation eval in _listEvaluations) {
      if (eval.getSender() == user) {
        found.add(eval);
      }
    }
    return found;
  }

  List<Evaluation> findReceivedEvaluationForProject(String project) {
    List<Evaluation> found = [];
    for (Evaluation eval in _listEvaluations) {
      if (eval.getProject() == project &&
          eval.getEvaluationMode() == EvaluationMode.PROJECT) found.add(eval);
    }
    return found;
  }

  List<Evaluation> findReceivedEvaluationForTeamOfProject(String project) {
    List<Evaluation> found = [];
    for (Evaluation eval in _listEvaluations) {
      if (eval.getProject() == project &&
          eval.getEvaluationMode() == EvaluationMode.TEAM) found.add(eval);
    }
    return found;
  }

  Future<List<Evaluation>> findByDesignersProject(
      List<Project> userProjects) async {
    List<Evaluation> found = [];
    List<Evaluation> toShow = [];
    for (Project project in userProjects)
      found.addAll(await findByProject(project.getId()));
    for (Evaluation eval in found) {
      if (eval.getEvaluationMode() == EvaluationMode.TEAM) {
        toShow.add(eval);
      }
    }
    return toShow;
  }
}
