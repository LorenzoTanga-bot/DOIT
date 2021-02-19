import 'package:doit/model/Candidacy.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/CandidacyProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendCandidacy extends StatefulWidget {
  final String id;

  const SendCandidacy({Key key, this.id}) : super(key: key);

  @override
  _SendCandidacy createState() => _SendCandidacy();
}

class _SendCandidacy extends State<SendCandidacy> {
  Project _project;
  TextEditingController _message = TextEditingController();

  @override
  void initState() {
    super.initState();
    _project = context.read<ProjectProvider>().findById(widget.id);
  }

  void createCandidacy() async {
    Candidacy newCandidacy = new Candidacy();
    newCandidacy.setDesigner(
        context.read<AuthCredentialProvider>().getUser().getMail());
    newCandidacy.setDateOfCandidacy(DateTime.now().toIso8601String());
    newCandidacy.setDateOfOutcome(DateTime.now().toIso8601String());
    if (_message.text.isNotEmpty) {
      newCandidacy.setMessage(_message.text);
    }
    newCandidacy.setState(StateCandidacy.WAITING);
    newCandidacy.setProjectProposer(_project.getProjectProposer());
    newCandidacy.setProject(_project.getId());
    context.read<CandidacyProvider>().addCandidacy(newCandidacy);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Send candidacy to " +
            _project.getProjectProposer() +
            " for the project" +
            _project.getName()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _message,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      "Inser a messag for project proposed (optional)",
                )),
            Divider(
              color: Colors.white,
              height: 20,
              thickness: 1,
              indent: 2,
              endIndent: 2,
            ),
            Text("Sei sicuro di volerti candidare al progetto " +
                _project.getName() +
                "?"),
            Divider(
              color: Colors.white,
              height: 20,
              thickness: 1,
              indent: 2,
              endIndent: 2,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () => {Navigator.pop(context)},
                child: Text("Back"),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () => {createCandidacy(), Navigator.pop(context)},
                child: Text("Candidate"),
              )
            ])
          ],
        ));
  }
}
