import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/widget/DoitAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:provider/provider.dart';
import 'package:swipedetector/swipedetector.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoitAppBar(),
      body: Center(
        child: SwipeDetector(
          child: context.watch<ViewProvider>().getViewPosition().elementAt(
              context.watch<ViewProvider>().getSelectedItemPosition()),
          onSwipeRight: () {
            setState(() {
              context.read<ViewProvider>().popWidget();
            });
          },
        ),
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
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onDoubleTap: () =>
                      context.read<ViewProvider>().dropFirstWidget(),
                  child: (Icon(Icons.home))),
              label: 'home'),
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onDoubleTap: () =>
                      context.read<ViewProvider>().dropSecondWidget(),
                  child: (Icon(Icons.search))),
              label: 'search'),
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onDoubleTap: () =>
                      context.read<ViewProvider>().dropThirdWidget(),
                  child: (Icon(Icons.person))),
              label: 'profile'),
        ],
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
      ),
    );
  }
}
