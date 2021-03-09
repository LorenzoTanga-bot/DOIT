import 'package:flutter/material.dart';

class DoitAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DoitAppBar({
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _DoitAppBar createState() => _DoitAppBar();
}

class _DoitAppBar extends State<DoitAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 10,
        title: Align(
          alignment: Alignment.topCenter,
          child: Image.asset('assets/images/logo.png', scale: 8),
        ));
  }
}
