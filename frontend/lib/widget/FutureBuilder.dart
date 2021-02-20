import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/widget/LoadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FutureBuild extends StatefulWidget {
  final Future future;
  final Widget newView;

  const FutureBuild({Key key, @required this.future, @required this.newView})
      : super(key: key);
  @override
  _FutureBuilder createState() => _FutureBuilder();
}

class _FutureBuilder extends State<FutureBuild> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.future;
      context.read<ViewProvider>().pushWidget(widget.newView);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new LoadingScreen(message: "Loading");
  }
}
