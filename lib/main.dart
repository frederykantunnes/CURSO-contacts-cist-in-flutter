import 'package:flutter/material.dart';

void main(){
  runApp(new MaterialApp(
    title: "Agenda de Contatos",
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Contatos"),
      ),
      body: new Container(),
    );
  }
}
