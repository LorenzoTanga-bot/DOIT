import 'package:doit/model/Invite.dart';

abstract class InviteService {
  Future<Invite> addInvite(Invite invite);
  Future<Invite> updateStateDesigner(Invite invite);
  Future<Invite> updateStateProjectProposer(Invite invite);
  Future<Invite> findById(String id);
  Future<List<Invite>> findByIds(List<String> ids);
  Future<List<Invite>> findByDesigner(String designer);
  Future<List<Invite>> findByProjectProposer(String projectProposer);
  Future<List<Invite>> findByProject(String project);
  Future<List<Invite>> findBySender(String sender);
}
