import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/SearchProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/services/backendservice/BackendAuthCredential.dart';
import 'package:doit/services/backendservice/BackendProjectservice.dart';
import 'package:doit/services/backendservice/BackendTagService.dart';
import 'package:doit/services/backendservice/BackendUserService.dart';
import 'package:doit/view/LoadingView.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  String _ip = "localhost";
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ViewProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                AuthCredentialProvider(new BackendAuthCredential(_ip))),
        ChangeNotifierProvider(
            create: (context) => TagProvider(new BackendTagService(_ip))),
        ChangeNotifierProvider(
            create: (context) =>
                ProjectProvider(new BackEndProjectService(_ip))),
        ChangeNotifierProvider(
            create: (context) => UserProvider(new BackendUserService(_ip)))
      ],
      child: Doit(),
    ),
  );
}

class Doit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: MaterialApp(
          title: "DOIT",
          debugShowCheckedModeBanner: false,
          home: LoadingView()),
    );
  }
}

class CustomOptions implements AppThemeOptions {
  final String filename;
  final Brightness brightness;
  CustomOptions({
    @required this.filename,
    @required this.brightness,
  });
}
