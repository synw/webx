import 'package:flutter/material.dart';
import 'package:webx/webx.dart';

import '../router.dart';

class _App1SidebarState extends State<App1Sidebar> {
  _App1SidebarState({@required this.category});

  final String category;

  @override
  void initState() {
    print("Init state sidebar $category");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RaisedButton(
          child: const Text("Category 1"),
          color: category == "category1" ? Colors.red : Colors.blue,
          onPressed: () => router.navigateTo(context, "/app1/category1")),
      RaisedButton(
          child: const Text("Category 2"),
          color: category == "category2" ? Colors.red : Colors.blue,
          onPressed: () => router.navigateTo(context, "/app1/category2")),
      RaisedButton(
          child: const Text("Category 3"),
          color: category == "category3" ? Colors.red : Colors.blue,
          onPressed: () => router.navigateTo(context, "/app1/category3")),
    ]);
  }
}

class App1Sidebar extends StatefulWidget {
  const App1Sidebar({this.category, Key key}) : super(key: key);

  final String category;

  @override
  _App1SidebarState createState() => _App1SidebarState(category: category);
}
