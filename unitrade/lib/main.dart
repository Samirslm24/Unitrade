import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(UniTrade());
}

class UniTrade extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "UniTrade",
      home: HomePage(),
    );
  }
}
