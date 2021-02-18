enum StateInvite { WAITING, POSITIVE, NEGATIVE }

class Invite {
  String _id;
  String _designer;
  String _projectProposer;
  String _project;
  String _dateOfInvite;
  StateInvite _state;
  String _dateOfOutcome;
  String _message;

  Invite.complete(
      this._id,
      this._designer,
      this._projectProposer,
      this._project,
      this._dateOfInvite,
      this._state,
      this._dateOfOutcome,
      this._message);

  Invite();

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

  String getDateOfInvite() {
    return this._dateOfInvite;
  }

  void setDateOfInvite(String dateOfInvite) {
    _dateOfInvite = dateOfInvite;
  }

  StateInvite getState() {
    return this._state;
  }

  void setState(StateInvite state) {
    _state = state;
  }

  String getDateOfOutcome() {
    return this._dateOfOutcome;
  }

  void setDateOfOutcome(String dateOfOutcome) {
    _dateOfOutcome = dateOfOutcome;
  }

  String getMessage() {
    return this._message;
  }

  void setMessage(String message) {
    _message = message;
  }
}
