import 'package:doit/model/AuthCredential.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/InitialSelection.dart';
import 'package:doit/view/projectproposer/ThreeViewPP.dart';
import 'package:doit/widget/LoadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingLogin extends StatefulWidget {
  @override
  _LoadingLogin createState() => _LoadingLogin();
}

class _LoadingLogin extends State<LoadingLogin> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<AuthCredentialProvider>().getUser().getRoles().first ==
              UserRole.NOT_COMPLETED
          ? context.read<ViewProvider>().setProfileDefault(InitialSelection())
          : context.read<ViewProvider>().setProfileDefault(ThreeViewPP());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new LoadingScreen(message: "Loading");
  }
}
