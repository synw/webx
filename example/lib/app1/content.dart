import 'package:flutter/material.dart';

class _App1ContentState extends State<App1Content> {
  _App1ContentState({@required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Category: $category"),
    );
  }
}

class App1Content extends StatefulWidget {
  const App1Content({@required this.category, Key key}) : super(key: key);

  final String category;

  @override
  _App1ContentState createState() => _App1ContentState(category: category);
}
