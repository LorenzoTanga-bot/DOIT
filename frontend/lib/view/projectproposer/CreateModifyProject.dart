import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/widget/NewTagInsertion.dart';
import 'package:doit/widget/SmartSelectTag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateModifyProject extends StatefulWidget {
  final String id;

  const CreateModifyProject({Key key, this.id}) : super(key: key);

  @override
  _CreateModifyProject createState() => _CreateModifyProject();
}

class _CreateModifyProject extends State<CreateModifyProject> {
  int _currentStep = 0;
  Project _project;
  TextEditingController _name = TextEditingController();
  TextEditingController _sDescription = TextEditingController();
  TextEditingController _lDescription = TextEditingController();
  bool _evaluationMode = false;
  bool _candidacyMode = false;
  DateFormat _df = DateFormat("dd/MM/yyyy");
  DateTime _dateOfStartProject = DateTime.now();
  DateTime _dateOfEndProject = DateTime.now();
  DateTime _dateOfStartCandidacy = DateTime.now();
  DateTime _dateOfEndCandidacy = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.id.isNotEmpty) {
      _project = context.read<ProjectProvider>().findById(widget.id);
      _name.text = _project.getName();
      _sDescription.text = _project.getShortDescription();
      _lDescription.text = _project.getDescription();
      _evaluationMode = _project.getEvaluationMode();
      _dateOfStartProject = DateTime.parse(_project.getDateOfStart());
      _dateOfEndProject = DateTime.parse(_project.getDateOfEnd());
      _dateOfStartCandidacy = DateTime.parse(_project.getStartCandidacy());
      _dateOfEndCandidacy = DateTime.parse(_project.getEndCandidacy());
      context.read<TagProvider>().setSelectTag(_project.getTag());
    } else
      _project = new Project();
  }

  _createProject() async {
    _project.setProjectProposer(
        context.read<AuthCredentialProvider>().getUser().getId());
    _project.setName(_name.text);
    _project.setTag(context.read<TagProvider>().getSelectTag());
    _project.setDateOfCreation(DateTime.now().toIso8601String());
    _project.setDateOfStart(_dateOfStartProject.toIso8601String());
    _project.setDateOfEnd(_dateOfEndProject.toIso8601String());
    _project.setShortDescription(_sDescription.text);
    _project.setDescription(_lDescription.text);
    _project.setEvaluationMode(_evaluationMode);
    _project.setStartCandidacy(_dateOfStartCandidacy.toIso8601String());
    _project.setEndCandidacy(_dateOfEndCandidacy.toIso8601String());
    context.read<ProjectProvider>().addProject(_project);
    context.read<ViewProvider>().popWidget();
  }

  void _getDate(context, String type) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (date != null)
      switch (type) {
        case "dStart":
          setState(() => _dateOfStartProject = date);
          break;
        case "dEnd":
          setState(() => _dateOfEndProject = date);
          break;
        case "cStart":
          setState(() => _dateOfStartCandidacy = date);
          break;
        case "cEnd":
          setState(() => _dateOfEndCandidacy = date);
      }
  }

  Widget _insertPrincipalInformations() {
    return Column(children: [
      TextField(
          controller: _name,
          decoration: InputDecoration(labelText: 'Project\'s name')),
      TextField(
          controller: _sDescription,
          maxLines: 5,
          decoration: InputDecoration(labelText: 'Short description')),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Project's Start:"),
          Text(_df.format(_dateOfStartProject)),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => _getDate(context, "dStart"),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Project's End:"),
          Text(_df.format(_dateOfEndProject)),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => _getDate(context, "dEnd"),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Evaluation:"),
          Switch(
            value: _evaluationMode,
            onChanged: (value) {
              setState(() {
                _evaluationMode = value;
              });
            },
            activeTrackColor: Colors.lightBlueAccent,
            activeColor: Colors.blue,
          ),
          Text("Candidacy:"),
          Switch(
            value: _candidacyMode,
            onChanged: (value) {
              setState(() {
                _candidacyMode = value;
              });
            },
            activeTrackColor: Colors.lightBlueAccent,
            activeColor: Colors.blue,
          ),
        ],
      ),
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Start \ncandidacy:"),
              Text(_df.format(_dateOfStartCandidacy)),
              IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () =>
                    _candidacyMode ? _getDate(context, "cStart") : null,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("End \ncandidacy:"),
              Text(_df.format(_dateOfEndCandidacy)),
              IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () =>
                    _candidacyMode ? _getDate(context, "cEnd") : null,
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  Widget _insertDescription() {
    return TextField(
        controller: _lDescription,
        maxLines: 15,
        decoration: InputDecoration(labelText: 'Description'));
  }

  Widget _insertTag() {
    return Column(
      children: [
        SmartSelectTag(title: "Tag"),
        RaisedButton.icon(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return NewTagInsertion(context: context);
                  });
            },
            label: Text('NEW TAG'),
            color: Colors.blue)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stepper(
      type: StepperType.horizontal,
      currentStep: _currentStep,
      onStepTapped: (int step) => setState(() => _currentStep = step),
      onStepContinue:
          _currentStep < 3 ? () => setState(() => _currentStep += 1) : null,
      onStepCancel:
          _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.navigate_before),
                label: Text('BACK'),
                onPressed: onStepCancel,
              ),
              _currentStep == 2 // this is the last step
                  ? RaisedButton.icon(
                      icon: Icon(Icons.create),
                      onPressed: _createProject,
                      label: Text('CREATE'),
                      color: Colors.blue,
                    )
                  : RaisedButton.icon(
                      icon: Icon(Icons.navigate_next),
                      onPressed: onStepContinue,
                      label: Text('CONTINUE'),
                      color: Colors.blue,
                    )
            ],
          ),
        );
      },
      steps: <Step>[
        new Step(
          title: new Text(''),
          content: _insertPrincipalInformations(),
          isActive: _currentStep >= 0,
          state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
        ),
        new Step(
          title: new Text(''),
          content: _insertDescription(),
          isActive: _currentStep >= 1,
          state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
        ),
        new Step(
          title: new Text(''),
          content: _insertTag(),
          isActive: _currentStep >= 2,
          state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
        )
      ],
    ));
  }
}