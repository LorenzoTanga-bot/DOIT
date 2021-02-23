enum EvaluationMode { PROJECT, TEAM }

class Evaluation {
  String _id;
  String _sender;
  String _project;
  String _message;
  EvaluationMode _evaluationMode;

  Evaluation();

  Evaluation.complete(this._id, this._sender, this._project, this._message,
      this._evaluationMode);

  String getId() {
    return _id;
  }

  void setId(String id) {
    _id = id;
  }

  String getSender() {
    return _sender;
  }

  void setSender(String sender) {
    _sender = sender;
  }

  String getProject() {
    return _project;
  }

  void setProject(String project) {
    _project = project;
  }

  String getMessage() {
    return _message;
  }

  void setMessage(String message) {
    _message = message;
  }

  EvaluationMode getEvaluationMode() {
    return _evaluationMode;
  }

  void setEvaluationMode(EvaluationMode evaluationMode) {
    _evaluationMode = evaluationMode;
  }
}
