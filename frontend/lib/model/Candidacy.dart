enum StateCandidacy { WAITING, POSITIVE, NEGATIVE }

class Candidacy {
  String _id;
  String _designer;
  String _projectProposer;
  String _project;
  String _dateOfCandidacy;
  StateCandidacy _state;
  String _dateOfOutcome;

  Candidacy(this._id, this._designer, this._projectProposer, this._project,
      this._dateOfCandidacy, this._state, this._dateOfOutcome);

  String getId() {
    return this._id;
  }

  void setId(String id) {
    _id = id;
  }

  String getDesigner() {
    return this._designer;
  }

  void setDesigner(String designer) {
    _designer = designer;
  }

  String getProjectProposer() {
    return this._projectProposer;
  }

  void setProjectProposer(String projectProposer) {
    _projectProposer = projectProposer;
  }

  String getProject() {
    return this._project;
  }

  void setProject(String project) {
    _project = project;
  }

  String getDateOfCandidacy() {
    return this._dateOfCandidacy;
  }

  void setDateOfCandidacy(String dateOfCandidacy) {
    _dateOfCandidacy = dateOfCandidacy;
  }

  StateCandidacy getState() {
    return this._state;
  }

  void setState(StateCandidacy state) {
    _state = state;
  }

  String getDateOfOutcome() {
    return this._dateOfOutcome;
  }

  void setDateOfOutcome(String dateOfOutcome) {
    _dateOfOutcome = dateOfOutcome;
  }
}
