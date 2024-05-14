import 'package:flutter/material.dart';

import './singleplayer_screen.dart';

class homeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 127, 33),
      body: Container(
        margin:
            EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0, bottom: 20.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 200.0),
              ),
              Text(
                "Frustration",
                style: TextStyle(fontSize: 50.0, fontFamily: 'PoetsenOne'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 230, 234, 236)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 22, 127, 213)),
                          fixedSize:
                              MaterialStateProperty.all(Size(170, 50))),
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => singlePlayerScreen()));
                      },
                      child: Text("Singleplayer",
                          style: TextStyle(fontSize: 20.0))),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 230, 234, 236)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 22, 127, 213)),
                          fixedSize:
                              MaterialStateProperty.all(Size(170, 50))),
                      onPressed: () {},
                      child:
                          Text("Multiplayer", style: TextStyle(fontSize: 20.0)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
