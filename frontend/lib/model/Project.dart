class Project {
  String _id;
  String _name;
  String _projectProposer;
  List<String> _tag;
  String _dateOfCreation;
  String _dateOfStart;
  String _dateOfEnd;
  String _shortDescription;
  bool _descriptionIsAFile;
  String
      _description; // if descriptionIsAFile is true, in this variable there will be saved the path of the file else the description
  bool _evaluationMode; // if it's true, the project is in evaluation mode.
  String _startEvaluation;
  String _endEvaluation;
  bool _candidacyMode; // if it's true, the project is in candidacy mode.
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
      bool descriptionIsAFile,
      String description,
      bool evaluationMode,
      String startEvaluation,
      String endEvaluation,
      bool candidacyMode,
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
    this._descriptionIsAFile = descriptionIsAFile;
    this._description = description;
    this._evaluationMode = evaluationMode;
    this._startEvaluation = startEvaluation;
    this._endEvaluation = endEvaluation;
    this._candidacyMode = candidacyMode;
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

  bool getDescriptionIsAFile() {
    return _descriptionIsAFile;
  }

  bool setDescriptionIsAFile(bool descriptionIsAFile) {
    _descriptionIsAFile = descriptionIsAFile;
    return true;
  }

  String getDescription() {
    return _description;
  }

  bool setDescription(String description) {
    _description = description;
    return true;
  }

  bool getEvaluationMode() {
    return _evaluationMode;
  }

  bool setEvaluationMode(bool evaluationMode) {
    _evaluationMode = evaluationMode;
    return true;
  }

  String getStartEvaluation() {
    return _startEvaluation;
  }

  bool setStartEvaluation(String startEvaluation) {
    _startEvaluation = startEvaluation;
    return true;
  }

  String getEndEvaluation() {
    return _endEvaluation;
  }

  bool setEndEvaluation(String endEvaluation) {
    _endEvaluation = endEvaluation;
    return true;
  }

  bool getCandidacyMode() {
    return _candidacyMode;
  }

  bool setCandidacyMode(bool candidacyMode) {
    _candidacyMode = candidacyMode;
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
