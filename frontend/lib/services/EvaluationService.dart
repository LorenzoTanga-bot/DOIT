import 'package:doit/model/Evaluation.dart';

abstract class EvaluationService {
  Future<Evaluation> addEvaluation(Evaluation evaluation);
  Future<Evaluation> updateEvaluation(Evaluation evaluation);
  Future<Evaluation> findbyId(String id);
  Future<List<Evaluation>>  findByIds(List<String> ids);
  Future<List<Evaluation>> findBySender(String sender);
  Future<List<Evaluation>> findByProject(String project);


}
