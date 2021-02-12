import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProfileOverView.dart';
import 'package:doit/view/ThirdView.dart';
import 'package:doit/widget/NewTagInsertion.dart';
import 'package:doit/widget/SmartSelectTag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class Signin extends StatefulWidget {
  final bool isAPerson;
  final String mail;

  const Signin({Key key, @required this.isAPerson, @required this.mail})
      : super(key: key);
  @override
  _Signin createState() => _Signin();
}

class _Signin extends State<Signin> {
  TextEditingController _name = TextEditingController();
  TextEditingController _surname = TextEditingController();
  TextEditingController _username = TextEditingController();
  List<UserRole> _roles;

  _completeRegistration() async {
    User newUser = new User();
    newUser.setMail(widget.mail);
    newUser.setName(_name.text);
    newUser.setIsAPerson(widget.isAPerson);
    newUser.setSurname(_surname.text);
    newUser.setUsername(_username.text);
    newUser.setRoles(_roles);
    newUser.setTags(context.read<TagProvider>().getSelectTag("SIGNIN"));
    await Provider.of<AuthCredentialProvider>(context, listen: false)
        .addUser(newUser);
    context.read<ViewProvider>().setProfileDefault(ThirdView());
  }

  Widget _selectUserRole() {
    return SmartSelect<UserRole>.multiple(
      title: 'Role',
      value: _roles,
      onChange: (state) => setState(() => _roles = state.value),
      choiceItems: <S2Choice<UserRole>>[
        if (!widget.isAPerson)
          S2Choice<UserRole>(
              value: UserRole.PROJECT_PROPOSER, title: 'PROJECT PROPOSER'),
        S2Choice<UserRole>(value: UserRole.DESIGNER, title: 'DESIGNER'),
        if (widget.isAPerson)
          S2Choice<UserRole>(value: UserRole.EXPERT, title: 'EXPERT'),
      ],
      choiceType: S2ChoiceType.switches,
      modalType: S2ModalType.bottomSheet,
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          isTwoLine: true,
          leading: Container(
            width: 40,
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
        SmartSelectTag(title: "Tags", index: "SIGNIN"),
        RaisedButton.icon(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return NewTagInsertion(context: context, index: "SIGNIN");
                  });
            },
            label: Text('NEW TAGS'),
            color: Colors.blue)
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
                TextField(
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    )),
                widget.isAPerson
                    ? TextField(
                        controller: _surname,
                        decoration: InputDecoration(labelText: 'Surname'))
                    : TextField(
                        controller: _surname,
                        decoration: InputDecoration(labelText: 'P.Iva')),
                TextField(
                    controller: _username,
                    decoration: InputDecoration(labelText: 'Username')),
                _selectUserRole(),
                _insertTags(),
                RaisedButton.icon(
                  icon: Icon(Icons.create),
                  onPressed: _completeRegistration,
                  label: Text('CREATE'),
                  color: Colors.blue,
                )
              ]),
            )));
  }
}
