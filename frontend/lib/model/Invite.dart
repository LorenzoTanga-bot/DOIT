enum StateInvite { WAITING, POSITIVE, NEGATIVE }

class Invite {
  String _id;
  String _designer;
  String _projectProposer;
  String _project;
  String _dateOfInvite;
  StateInvite _state;
  String _dateOfExpire;
  String _message;

  Invite.complete(
      this._id,
      this._designer,
      this._projectProposer,
      this._project,
      this._dateOfInvite,
      this._state,
      this._dateOfExpire,
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

  String getDateOfExpire() {
    return this._dateOfExpire;
  }

  void setDateOfExpire(String dateOfExpire) {
    _dateOfExpire = dateOfExpire;
  }

  String getMessage() {
    return this._message;
  }

  void setMessage(String message) {
    _message = message;
  }
}
