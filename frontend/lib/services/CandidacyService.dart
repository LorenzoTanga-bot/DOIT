import 'package:doit/model/Candidacy.dart';

abstract class CandidacyService {
  Future<Candidacy> addCandidacy(Candidacy candidacy);
  Future<Candidacy> updateCandidacy(Candidacy candidacy);
  Future<Candidacy> findById(String id);
  Future<List<Candidacy>> findByIds(List<String> ids);
  Future<List<Candidacy>> findByDesigner(String designer);
  Future<List<Candidacy>> findByProjectProposer(String projectProposer);
  Future<List<Candidacy>> findByProject(String project);
}
