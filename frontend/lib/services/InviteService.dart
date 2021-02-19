import 'package:doit/model/Invite.dart';

abstract class InviteService {
  Future<Invite> addInvite(Invite invite);
  Future<Invite> updateInvite(Invite invite);
  Future<Invite> findById(String id);
  Future<List<Invite>> findByIds(List<String> ids);
  Future<List<Invite>> findByDesigner(String designer);
  Future<List<Invite>> findByProjectProposer(String projectProposer);
  Future<List<Invite>> findByProject(String project);
}