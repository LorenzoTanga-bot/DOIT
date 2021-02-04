class Project {
  String _id;
  String _name;
  String _projectProposer;
  List<String> _tag;
  String _dateOfCreation;
  String _dateOfStart;
  String _dateOfEnd;
  String _shortDescription;
  String _description;
  bool _evaluationMode; // if it's true, the project has evaluation mode.
  String _startCandidacy;
  String _endCandidacy;

  Project();

  Project.fromJson(
      String id,
      String name,
      String projectProposer,
      List<String> tag,
      String dateOfCreation,
      String dateOfStart,
      String dateOfEnd,
      String shortDescription,
      String description,
      bool evaluationMode,
      String startCandidacy,
      String endCandidacy) {
    this._id = id;
    this._name = name;
    this._projectProposer = projectProposer;
    this._tag = tag;
    this._dateOfCreation = dateOfCreation;
    this._dateOfStart = dateOfStart;
    this._dateOfEnd = dateOfEnd;
    this._shortDescription = shortDescription;
    this._description = description;
    this._evaluationMode = evaluationMode;
    this._startCandidacy = startCandidacy;
    this._endCandidacy = endCandidacy;
  }

  String getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  bool setName(String name) {
    _name = name;
    return true;
  }

  String getProjectProposer() {
    return _projectProposer;
  }

  bool setProjectProposer(String projectProposer) {
    _projectProposer = projectProposer;
    return true;
  }

  List<String> getTag() {
    return _tag;
  }

  bool setTag(List<String> tag) {
    _tag = tag;
    return true;
  }

  String getDateOfCreation() {
    return _dateOfCreation;
  }

  bool setDateOfCreation(String dateOfCreation) {
    _dateOfCreation = dateOfCreation;
    return true;
  }

  String getDateOfStart() {
    return _dateOfStart;
  }

  bool setDateOfStart(String dateOfStart) {
    _dateOfStart = dateOfStart;
    return true;
  }

  String getDateOfEnd() {
    return _dateOfEnd;
  }

  bool setDateOfEnd(String dateOfEnd) {
    _dateOfEnd = dateOfEnd;
    return true;
  }

  String getShortDescription() {
    return _shortDescription;
  }

  bool setShortDescription(String shortDescription) {
    _shortDescription = shortDescription;
    return true;
  }

  String getDescription() {
    return _description;
  }

  bool setDescription(String description) {
    _description = description;
    return true;
  }

  bool getCandidacyMode() {
    DateTime now = DateTime.now();
    if (now.isBefore(DateTime.parse(_endCandidacy)) &&
        now.isAfter(DateTime.parse(_startCandidacy))) {
      return true;
    } else
      return false;
  }

  bool getEvaluationMode() {
    if (_evaluationMode == false)
      return false;
    else
      return !getCandidacyMode();
  }

  bool setEvaluationMode(bool evaluationMode) {
    _evaluationMode = evaluationMode;
    return true;
  }

  String getStartCandidacy() {
    return _startCandidacy;
  }

  bool setStartCandidacy(String startCandidacy) {
    _startCandidacy = startCandidacy;
    return true;
  }

  String getEndCandidacy() {
    return _endCandidacy;
  }

  bool setEndCandidacy(String endCandidacy) {
    _endCandidacy = endCandidacy;
    return true;
  }
}
