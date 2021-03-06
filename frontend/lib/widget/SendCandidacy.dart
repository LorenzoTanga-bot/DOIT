import 'package:doit/model/Candidacy.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/CandidacyProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/widget/ErrorPopUp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendCandidacy extends StatefulWidget {
  final String id;
 

  const SendCandidacy({Key key, @required this.id,})
      : super(key: key);

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
    newCandidacy.setDateOfExpire(_project.getDateOfStart());
    if (_message.text.isNotEmpty) {
      newCandidacy.setMessage(_message.text);
    }
    newCandidacy.setState(StateCandidacy.WAITING);
    newCandidacy.setProjectProposer(_project.getProjectProposer());
    newCandidacy.setProject(_project.getId());
    try {
      await context.read<CandidacyProvider>().addCandidacy(newCandidacy);
      Navigator.pop(context);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return ErrorPopup(message: e.toString());
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
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
                  hintText: "Inser a messag for project proposed (optional)",
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
              OutlinedButton(
                onPressed: () => {Navigator.pop(context)},
                child: Text("Back"),
              ),
              OutlinedButton(
                onPressed: () => {
                  createCandidacy(),
                },
                child: Text("Candidate"),
              )
            ])
          ],
        ));
  }
}
