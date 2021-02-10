import 'package:doit/model/AuthCredential.dart';

class User {
  String _mail;
  bool _isAPerson;
  String _username;
  String _name;
  String _surname; //se è una azienda qui viene salvata la Paritta iva
  List<UserRole> _roles = [];
  List<String> _tags = [];
  List<String> _proposedProjets=[];
  List<String> _partecipateInProjects=[];
  List<String> _evaluations=[];
  List<String> _invites=[];
  List<String> _candidacies=[];

  User();

  User.firstAccess(String mail) {
    _mail = mail;
    _roles.add(UserRole.NOT_COMPLETED);
  }

  User.complete(
      this._mail,
      this._isAPerson,
      this._username,
      this._name,
      this._surname,
      this._tags,
      this._roles,
      this._proposedProjets,
      this._partecipateInProjects,
      this._evaluations,
      this._invites,
      this._candidacies);

  bool setMail(String mail) {
    _mail = mail;
    return true;
  }

  String getMail() {
    return _mail;
  }

  bool getIsAperson() {
    return _isAPerson;
  }

  bool setIsAPerson(bool isAPerson) {
    _isAPerson = isAPerson;
    return true;
  }

  bool setUsername(String username) {
    _username = username;
    return true;
  }

  String getUsername() {
    return _username;
  }

  bool setName(String name) {
    _name = name;
    return true;
  }

  String getName() {
    return _name;
  }

  bool setSurname(String surname) {
    _surname = surname;
    return true;
  }

  String getSurname() {
    return _surname;
  }

  bool setRoles(List<UserRole> roles) {
    _roles = roles;
    return true;
  }

  List<UserRole> getRoles() {
    return _roles;
  }

  bool setTags(List<String> tags) {
    _tags = tags;
    return true;
  }

  List<String> getTags() {
    return _tags;
  }

  bool setProposedProjects(List<String> projects) {
    _proposedProjets = projects;
    return true;
  }

  bool addProposedProject(String idProject) {
    _proposedProjets.add(idProject);
    return true;
  }

  bool removeProposedProjects(String idProject) {
    return _proposedProjets.remove(idProject);
  }

  List<String> getProposedProjects() {
    return _proposedProjets;
  }

  bool setPartecipateInProjects(List<String> projects) {
    _partecipateInProjects = projects;
    return true;
  }

  bool addPartecipateInProject(String idProject) {
    _partecipateInProjects.add(idProject);
    return true;
  }

  bool removepPrtecipateInProject(String idProject) {
    return _partecipateInProjects.remove(idProject);
  }

  List<String> getPartecipateInProjects() {
    return _partecipateInProjects;
  }

  bool setEvaluations(List<String> evaluation) {
    _evaluations = evaluation;
    return true;
  }

  bool addEvaluations(String idEvaluations) {
    _evaluations.add(idEvaluations);
    return true;
  }

  bool removeEvaluations(String idEvaluations) {
    return _evaluations.remove(idEvaluations);
  }

  List<String> getEvaluations() {
    return _evaluations;
  }

  bool setCandidacies(List<String> candidacies) {
    _candidacies = candidacies;
    return true;
  }

  bool addCandidacy(String idCandidacy) {
    _candidacies.add(idCandidacy);
    return true;
  }

  bool removeCandidacy(String idCandidacy) {
    return _candidacies.remove(idCandidacy);
  }

  List<String> getCandidacies() {
    return _candidacies;
  }

  bool setInvites(List<String> invites) {
    _invites = invites;
    return true;
  }

  bool addInvite(String idInvite) {
    _invites.add(idInvite);
    return true;
  }

  bool removeInvite(String idInvite) {
    return _invites.remove(idInvite);
  }

  List<String> getInvites() {
    return _invites;
  }
}
