import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';

import 'package:doit/view/ThirdView.dart';
import 'package:doit/widget/ErrorPopUp.dart';

import 'package:doit/widget/NewTagInsertion.dart';
import 'package:doit/widget/SmartSelectTag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class CreateModifyProfile extends StatefulWidget {
  final bool isNewUser;

  const CreateModifyProfile({Key key, @required this.isNewUser})
      : super(key: key);
  @override
  _CreateModifyProfile createState() => _CreateModifyProfile();
}

class _CreateModifyProfile extends State<CreateModifyProfile> {
  TextEditingController _name = TextEditingController();
  TextEditingController _surname = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _biography = TextEditingController();
  User _user;
  List<UserRole> _roles;
  int group = 1;
  bool isAPerson = true;
  bool _visibilityLabelName = false;
  bool _visibilityLabelSurname = false;
  bool _visibilityLabelUsername = false;
  bool _visibilityLabelRoles = false;
  bool _visibilityLabelTags = false;

  initState() {
    super.initState();
    _user = context.read<AuthCredentialProvider>().getUser();
    if (!widget.isNewUser) {
      _name.text = _user.getName();
      _surname.text = _user.getSurname();
      _username.text = _user.getUsername();
      _roles = _user.getRoles();
      isAPerson = _user.getIsAPerson();
      context.read<TagProvider>().setSelectTag(_user.getTags(), "USER");
      _biography.text = _user.getBiography();
    }
  }

  bool _checkPrincipalInformation() {
    _visibilityLabelSurname = false;
    _visibilityLabelName = false;
    _visibilityLabelUsername = false;
    _visibilityLabelRoles = false;
    if (_name.text.isEmpty) {
      _visibilityLabelName = true;
      return false;
    }
    if (_surname.text.isEmpty) {
      _visibilityLabelSurname = true;
      return false;
    }
    if (_username.text.isEmpty) {
      _visibilityLabelUsername = true;
      return false;
    }
    if (_roles.isEmpty) {
      _visibilityLabelRoles = true;
      return false;
    }
    if (widget.isNewUser) {
      if (context.read<TagProvider>().getSelectTag("SIGNIN").isEmpty) {
        _visibilityLabelTags = true;
        return false;
      }
    } else if (context.read<TagProvider>().getSelectTag("USER").isEmpty) {
      _visibilityLabelTags = true;
      return false;
    }

    return true;
  }

  _continue() async {
    _user.setName(_name.text);
    _user.setSurname(_surname.text);
    _user.setUsername(_username.text);
    _user.setRoles(_roles);
    _user.setBiography(_biography.text);
    try {
      if (widget.isNewUser) {
        _user.setTags(context.read<TagProvider>().getSelectTag("SIGNIN"));
        await Provider.of<AuthCredentialProvider>(context, listen: false)
            .addUser(_user);
        context.read<ViewProvider>().setProfileDefault(ThirdView());
      } else {
        _user.setTags(context.read<TagProvider>().getSelectTag("USER"));
        await Provider.of<AuthCredentialProvider>(context, listen: false)
            .updateUser(_user);
        Provider.of<UserProvider>(context, listen: false)
            .reloadUser(_user.getMail());
        context.read<ViewProvider>().popWidget();
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return ErrorPopup(message: e.toString());
          });
    }
  }

  Widget _selectUserRole() {
    List<S2Choice<UserRole>> choice;
    if (!isAPerson)
      choice = [
        S2Choice<UserRole>(
            value: UserRole.PROJECT_PROPOSER, title: 'PROJECT PROPOSER'),
        S2Choice<UserRole>(value: UserRole.DESIGNER_ENTITY, title: 'DESIGNER'),
      ];
    else
      choice = [
        S2Choice<UserRole>(value: UserRole.EXPERT, title: 'EXPERT'),
        S2Choice<UserRole>(value: UserRole.DESIGNER_PERSON, title: 'DESIGNER'),
      ];
    return SmartSelect<UserRole>.multiple(
      title: 'Role',
      value: _roles,
      onChange: (state) => setState(() => _roles = state.value),
      choiceItems: choice,
      choiceType: S2ChoiceType.switches,
      modalType: S2ModalType.bottomSheet,
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          isTwoLine: true,
          leading: Container(
            width: 30,
            alignment: Alignment.center,
            child: Icon(Icons.tag),
          ),
        );
      },
    );
  }

  Widget _insertTags() {
    return Column(
      children: [
        widget.isNewUser
            ? SmartSelectTag(title: "Tag", index: "SIGNIN")
            : SmartSelectTag(title: "Tag", index: "USER"),
        if (!widget.isNewUser)
          OutlinedButton.icon(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return NewTagInsertion(context: context, index: "USER");
                  });
            },
            label: Text('NEW TAG'),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(children: [
                if (widget.isNewUser)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          child: Text(
                            "Complete registration",
                            style: TextStyle(fontSize: 35),
                          ),
                          alignment: Alignment.center,
                        ),
                        Divider(
                          color: Colors.white,
                          height: 17,
                          thickness: 1,
                          indent: 2,
                          endIndent: 2,
                        ),
                        Text(
                          "You are a :",
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Person",
                              style: TextStyle(fontSize: 17),
                            ),
                            Radio(
                                value: 1,
                                groupValue: group,
                                onChanged: (value) {
                                  setState(() {
                                    isAPerson = true;
                                    group = value;
                                  });
                                }),
                            Text("Entity", style: TextStyle(fontSize: 17)),
                            Radio(
                              value: 2,
                              groupValue: group,
                              onChanged: (value) {
                                setState(() {
                                  isAPerson = false;
                                  group = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ])
                else
                  Text(
                    "Modify your profile",
                    style: TextStyle(fontSize: 35),
                  ),
                TextField(
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    )),
                Visibility(
                  child: Text("The name cannot be empty",
                      style: TextStyle(color: Colors.red)),
                  visible: _visibilityLabelName,
                ),
                isAPerson
                    ? TextField(
                        controller: _surname,
                        decoration: InputDecoration(labelText: 'Surname'))
                    : TextField(
                        controller: _surname,
                        decoration: InputDecoration(labelText: 'P.Iva')),
                isAPerson
                    ? Visibility(
                        child: Text("The surname cannot be empty",
                            style: TextStyle(color: Colors.red)),
                        visible: _visibilityLabelSurname,
                      )
                    : Visibility(
                        child: Text("The P.Iva cannot be empty",
                            style: TextStyle(color: Colors.red)),
                        visible: _visibilityLabelSurname,
                      ),
                if (widget.isNewUser)
                  TextField(
                      controller: _username,
                      decoration: InputDecoration(labelText: 'Username'))
                else
                  Container(
                      padding: EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("Username",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12))),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(_user.getUsername(),
                                  style: TextStyle(fontSize: 15))),
                          Divider(
                            color: Colors.white,
                            height: 10,
                            thickness: 1,
                            indent: 2,
                            endIndent: 2,
                          ),
                          Divider(
                            color: Colors.grey,
                            height: 5,
                            thickness: 1,
                            indent: 2,
                            endIndent: 2,
                          ),
                          TextField(
                              controller: _biography,
                              decoration: InputDecoration(
                                labelText: 'Biography',
                              )),
                        ],
                      )),
                if (widget.isNewUser)
                  Visibility(
                    child: Text("The username cannot be empty",
                        style: TextStyle(color: Colors.red)),
                    visible: _visibilityLabelUsername,
                  ),
                if (widget.isNewUser)
                  Divider(
                    color: Colors.grey,
                    height: 5,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                _selectUserRole(),
                Visibility(
                  child: Text("Select at least one role",
                      style: TextStyle(color: Colors.red)),
                  visible: _visibilityLabelRoles,
                ),
                _insertTags(),
                Visibility(
                  child: Text("Select at least one tag",
                      style: TextStyle(color: Colors.red)),
                  visible: _visibilityLabelTags,
                ),
                OutlinedButton.icon(
                  icon: Icon(Icons.create),
                  onPressed: () => {
                    if (_checkPrincipalInformation())
                      _continue()
                    else
                      setState(() {})
                  },
                  label: Text('CREATE'),
                )
              ]),
            )));
  }
}
