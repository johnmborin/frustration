import 'package:flutter/material.dart';

import './deck.dart';

class singlePlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("t")),
      body: Container(
        //margin: EdgeInsets.all(30.0),
        child: Center (
        child: ElevatedButton(
          child: Text("Shuffle"),
          onPressed: () {
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => CardPage()));
          }
        )
        )
      )
    );
  }

}