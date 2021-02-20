import 'package:doit/model/Invite.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/InviteProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';

import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CardList.dart';

class SendInvite extends StatefulWidget {
  final String id;

  const SendInvite({Key key, @required this.id}) : super(key: key);

  @override
  _SendInvite createState() => _SendInvite();
}

class _SendInvite extends State<SendInvite> {
  Project _project;
  int _currentStep = 0;
  List<User> _usersFind = [];
  User _designer;
  TextEditingController _message = TextEditingController();
  bool _visibilityLabelDesigner = false;

  @override
  void initState() {
    super.initState();
    _project = context.read<ProjectProvider>().findById(widget.id);
  }

  void createInvite() async {
    Invite newInvite = new Invite();
    newInvite.setDesigner(_designer.getMail());
    newInvite.setDateOfInvite(DateTime.now().toIso8601String());
    newInvite.setDateOfExpire(_project.getDateOfStart());
    if (_message.text.isNotEmpty) {
      newInvite.setMessage(_message.text);
    }
    //newInvite.setState(StateInvite.WAITING);
    newInvite.setProjectProposer(
        context.read<AuthCredentialProvider>().getUser().getMail());
    newInvite.setProject(_project.getId());
    context.read<InviteProvider>().addInvite(newInvite);
  }

  void buildSuggestions(BuildContext context, String query) async {
    if (query.isEmpty) {
      _usersFind = [];
      setState(() {});
    } else {
      _visibilityLabelDesigner = false;
      await searchUsers(query, context);
      setState(() {});
    }
  }

  Future searchUsers(String query, BuildContext context) async {
    List<User> usersTemp = [];
    usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
        .findByUsername(query, "DESIGNER"));
    _usersFind = usersTemp;
  }

  void selectDesigner(String mail) async {
    _designer = await Provider.of<UserProvider>(context, listen: false)
        .findUserByMail(mail);
    setState(() {
      _currentStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    StepperType stepperType = StepperType.horizontal;

    return Scaffold(
      body: Stepper(
          type: stepperType,
          physics: ScrollPhysics(),
          currentStep: _currentStep,
          onStepContinue: continued,
          onStepCancel: cancel,
          steps: <Step>[
            Step(
              title: new Text(""),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    onChanged: (val) {
                      buildSuggestions(context, val);
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Search designer',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                  ),
                  Visibility(
                    child: Text("The surname cannot be empty",
                        style: TextStyle(color: Colors.red)),
                    visible: _visibilityLabelDesigner,
                  ),
                  if (_usersFind.isNotEmpty)
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: _usersFind.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              child: CardList(
                                  name: _usersFind[index].getUsername(),
                                  sDescription: _usersFind[index].getName() +
                                      " " +
                                      _usersFind[index].getSurname()),
                              onTap: () {
                                selectDesigner(_usersFind[index].getMail());
                              });
                        }),
                ],
              ),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 0 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Text(""),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                      controller: _message,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Insert a message for designer (optional)",
                      )),
                  Divider(
                    color: Colors.white,
                    height: 20,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  if (_designer != null)
                    Text("Sei sicuro di voler invitare " +
                        _designer.getName() +
                        " " +
                        _designer.getSurname() +
                        "?"),
                  Divider(
                    color: Colors.white,
                    height: 20,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 1 ? StepState.complete : StepState.disabled,
            ),
          ]),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_designer != null) {
      if (_currentStep == 0)
        setState(() => _currentStep += 1);
      else {
        if (_currentStep == 1) {
          createInvite();
          Provider.of<ViewProvider>(context, listen: false).popWidget();
        }
      }
    } else {
      _visibilityLabelDesigner = true;
      setState(() => {});
    }
  }

  cancel() {
    if (_currentStep == 0)
      Provider.of<ViewProvider>(context, listen: false).popWidget();
    if (_currentStep == 1) {
      _designer = null;
      _visibilityLabelDesigner = false;
      _usersFind = [];
      setState(() => _currentStep -= 1);
    }
  }
}
