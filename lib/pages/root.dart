import 'package:flutter/material.dart';
import 'package:relaxing_collection/pages/home/home.dart';
import 'package:relaxing_collection/pages/settings/settings.dart';

class Root extends StatefulWidget{
  const Root({super.key});
  
  @override
  State<StatefulWidget> createState() => RootState();
}

class RootState extends State<Root> {
  late Future _initFuture;
  int _navBarSelectedIndex = 0;
  bool _navBarSelected = false;
  final PageController _pageController = PageController();

  Future<bool> _init() async {
    return true;
  }

  @override
  void initState() {
    super.initState();

    _initFuture = _init();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return Scaffold(
          body: Stack(
            children: [
              PageView(
                controller: _pageController,
                children: [
                  const Home(),
                  const Settings()
                ],
                onPageChanged: (value) {
                  if (!_navBarSelected) {
                    setState(() {
                      _navBarSelectedIndex = value;
                    });
                  }
                },
              )
            ],
          ),
          bottomNavigationBar: NavigationBar(
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(icon: Icon(Icons.settings), label: "Settings")
            ],
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: _navBarSelectedIndex,
            onDestinationSelected: (value) async {
              _navBarSelected = true;

              setState(() {
                _navBarSelectedIndex = value;
              });

              await _pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut
              );

              _navBarSelected = false;
            },
          ),
        );
      },
    );
  }
}