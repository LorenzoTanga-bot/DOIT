import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/widget/DoitAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _view;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoitAppBar(),
      body: Center(
        child: context
            .watch<ViewProvider>()
            .getViewPosition()
            .elementAt(context.watch<ViewProvider>().getSelectedItemPosition()),
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.pinned,
        snakeShape: SnakeShape.circle,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        currentIndex: context.watch<ViewProvider>().getSelectedItemPosition(),
        onTap: (index) => setState(
            () => context.read<ViewProvider>().setSelectedItemPosition(index)),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
      ),
    );
  }
}
