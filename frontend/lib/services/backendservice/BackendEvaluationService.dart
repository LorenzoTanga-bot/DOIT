import 'dart:convert';

import 'package:doit/apicontroller/EvaluationApiController.dart';
import 'package:doit/model/Evaluation.dart';
import 'package:doit/services/EvaluationService.dart';

class BackendEvaluationService implements EvaluationService {
  EvaluationApiController _controller;

  BackendEvaluationService(String ip) {
    _controller = new EvaluationApiController(ip);
  }
  List<Evaluation> _createListEvaluations(String controllerJson) {
    if (controllerJson == "") return null;
    var listEvaluations = json.decode(controllerJson);
    List<Evaluation> evaluations = [];
    for (var evaluation in listEvaluations) {
      evaluations.add(_newEvaluation(evaluation));
    }
    return evaluations;
  }

  Evaluation _newEvaluation(var evaluation) {
    return new Evaluation.complete(
      evaluation["id"],
      evaluation["sender"],
      evaluation["project"],
      evaluation["message"],
      EvaluationMode.values.firstWhere((e) =>
          e.toString() == 'EvaluationMode.' + evaluation["evaluationMode"]),
    );
  }

  Evaluation _createEvaluation(String controllerJson) {
    if (controllerJson == "") return null;
    return _newEvaluation(json.decode(controllerJson));
  }

  @override
  Future<Evaluation> addEvaluation(Evaluation evaluation) async {
    return _createEvaluation(await _controller.addEvaluation(evaluation));
  }

  @override
  Future<List<Evaluation>> findByIds(List<String> ids) async {
    return _createListEvaluations(await _controller.getEvaluationsByIds(ids));
  }

  @override
  Future<List<Evaluation>> findByProject(String project) async {
    return _createListEvaluations(
        await _controller.getEvaluationsByProject(project));
  }

  @override
  Future<List<Evaluation>> findBySender(String sender) async {
    return _createListEvaluations(
        await _controller.getEvaluationsBySender(sender));
  }

  @override
  Future<Evaluation> findbyId(String id) async {
    return _createEvaluation(await _controller.getEvaluationById(id));
  }

  @override
  Future<Evaluation> updateEvaluation(Evaluation evaluation) async {
    return _createEvaluation(await _controller.updateEvaluation(evaluation));
  }
}
