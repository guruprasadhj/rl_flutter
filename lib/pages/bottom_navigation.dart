import 'package:flutter/material.dart';
import 'package:rl_flutter/pages/first_page.dart';
import 'package:rl_flutter/pages/greetings_page.dart';
import 'package:rl_flutter/pages/webview_page.dart';
import 'package:rl_flutter/pages/search_page.dart';

// ////////////////////////// BOTTOM NAVIGATION BAR ////////////////////////////
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  final screens = [
    DataLoaderPage(),
    OfflineDataPage(),
    Greetings(),
    WebViewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(
            () => (this.index = index),
          ),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.downloading_sharp), label: "Load"),
            NavigationDestination(
                icon: Icon(Icons.search_sharp), label: "Filter"),
            NavigationDestination(icon: Icon(Icons.graphic_eq), label: "greet"),
            NavigationDestination(icon: Icon(Icons.webhook), label: "webview"),
          ],
        ),
      ),
    );
  }
}
