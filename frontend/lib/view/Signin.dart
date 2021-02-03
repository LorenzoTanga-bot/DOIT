import 'package:doit/model/User.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/LoadingLogin.dart';
import 'package:doit/widget/NewTagInsertion.dart';
import 'package:doit/widget/SmartSelectTag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class Signin extends StatefulWidget {
  @override
  _Signin createState() => _Signin();
}

class _Signin extends State<Signin> {
  TextEditingController _name = TextEditingController();
  TextEditingController _surname = TextEditingController();
  TextEditingController _username = TextEditingController();
  UserRole _role;

  _completeRegistration() {
    User newUser =
        Provider.of<UserProvider>(context, listen: false).getSpringUser();
    newUser.setName(_name.text);
    newUser.setSurname(_surname.text);
    newUser.setUsername(_username.text);
    newUser.setRole(_role);
    newUser.setSkills(context.read<TagProvider>().getSelectTag());
    context.read<UserProvider>().updateUser(newUser);
    context.read<ViewProvider>().setProfileDefault(LoadingLogin());
  }

  Widget _selectUserRole() {
    return SmartSelect<UserRole>.single(
      title: 'Role',
      value: _role,
      onChange: (state) => setState(() => _role = state.value),
      choiceItems: <S2Choice<UserRole>>[
        S2Choice<UserRole>(
            value: UserRole.PROJECT_PROPOSER, title: 'PROJECT PROPOSER'),
        S2Choice<UserRole>(value: UserRole.DESIGNER, title: 'DESIGNER'),
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

  Widget _insertSkills() {
    return Column(
      children: [
        SmartSelectTag(title: "Skills"),
        RaisedButton.icon(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return NewTagInsertion(context: context);
                  });
            },
            label: Text('NEW SKILL'),
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
                TextField(
                    controller: _surname,
                    decoration: InputDecoration(labelText: 'Surname')),
                TextField(
                    controller: _username,
                    decoration: InputDecoration(labelText: 'Username')),
                _selectUserRole(),
                _insertSkills(),
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
