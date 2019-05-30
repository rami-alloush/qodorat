import 'package:flutter/material.dart';

class PlaceholderPage extends StatefulWidget {
  PlaceholderPage({@required this.title});

  final String title;

  @override
  _PlaceholderPageState createState() => _PlaceholderPageState();
}

class _PlaceholderPageState extends State<PlaceholderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '${widget.title}',
          textAlign: TextAlign.center,
          style: TextStyle(
//          color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
