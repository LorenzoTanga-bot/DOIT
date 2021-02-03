import 'package:doit/model/User.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/Signin.dart';
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
      if (context.read<UserProvider>().getSpringUser() == null)
        Provider.of<UserProvider>(context, listen: false).isFirstAccess()
            ? await Provider.of<UserProvider>(context, listen: false)
                .newSpringUser()
            : await Provider.of<UserProvider>(context, listen: false)
                .authSpringUser();
      switch (context.read<UserProvider>().getSpringUser().getRole()) {
        case UserRole.PROJECT_PROPOSER:
          context.read<ViewProvider>().setProfileDefault(ThreeViewPP());
          break;
        case UserRole.EXPERT:
          // TODO: Handle this case.
          break;
        case UserRole.DESIGNER:
          // TODO: Handle this case.
          break;
        case UserRole.NOT_COMPLETED:
          context.read<ViewProvider>().setProfileDefault(Signin());
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new LoadingScreen(message: "Loading");
  }
}
