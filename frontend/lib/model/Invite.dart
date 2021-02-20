enum StateInvite { WAITING, POSITIVE, NEGATIVE, EXPIRED }

class Invite {
  String _id;
  String _sender;
  String _designer;
  String _projectProposer;
  String _project;
  StateInvite _stateProjectProposer;
  StateInvite _stateDesigner;
  String _dateOfInvite;
  String _dateOfExpire;
  String _message;

  Invite.complete(
      this._id,
      this._sender,
      this._designer,
      this._projectProposer,
      this._project,
      this._stateProjectProposer,
      this._stateDesigner,
      this._dateOfInvite,
      this._dateOfExpire,
      this._message);

  Invite();

  String getId() {
    return this._id;
  }

  void setId(String id) {
    _id = id;
  }

  String getSender() {
    return this._sender;
  }

  void setSender(String sender) {
    this._sender = sender;
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
    if (this._stateDesigner == StateInvite.POSITIVE &&
        this._stateProjectProposer == StateInvite.POSITIVE)
      return StateInvite.POSITIVE;
    if (this._stateDesigner == StateInvite.NEGATIVE ||
        this._stateProjectProposer == StateInvite.NEGATIVE)
      return StateInvite.NEGATIVE;
    if (DateTime.parse(this._dateOfExpire).isBefore(DateTime.now()))
      return StateInvite.EXPIRED;
    else
      return StateInvite.WAITING;
  }

  StateInvite getStateDesigner() {
    return this._stateDesigner;
  }

  void setStateDesigner(StateInvite stateDesigner) {
    _stateDesigner = stateDesigner;
  }

  StateInvite getStateProjectProposer() {
    return this._stateProjectProposer;
  }

  void setStateProjectProposer(StateInvite stateProjectProposer) {
    _stateProjectProposer = stateProjectProposer;
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
