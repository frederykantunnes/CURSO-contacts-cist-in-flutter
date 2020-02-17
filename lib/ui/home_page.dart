import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_contacts_agend/helpers/ContactHelper.dart';
import 'package:flutter_app_contacts_agend/ui/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ContactHelper helper = ContactHelper();

  List<Contact> list = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _getAllContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Contatos"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new ListView.builder(
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index){
            return _contactCard(context, index);
          },
        itemCount: list.length,
          ),

      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          backgroundColor: Colors.red,
          onPressed: (){
            _showContactPage();
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      onTap: (){
//        _showContactPage(contact: list[index]);
      _showOptions(context, index);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: list[index].image != null ? FileImage(File(list[index].image)) : AssetImage("images/person.png")
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(list[index].name ?? "", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                    Text(list[index].email ?? "", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text(list[index].phone ?? "", style: TextStyle(fontSize: 18))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  
  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(context: context, builder: (context){
      return BottomSheet(
        onClosing: (){},
        builder: (context){
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                    child: Text("Ligar", style: TextStyle(color: Colors.red, fontSize: 20),),
                    onPressed: (){
                      Navigator.pop(context);
                      launch("tel:${list[index].phone}");
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                    child: Text("Editar", style: TextStyle(color: Colors.red, fontSize: 20),),
                    onPressed: (){
                      Navigator.pop(context);
                      _showContactPage(contact: list[index]);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                    child: Text("Excluir", style: TextStyle(color: Colors.red, fontSize: 20),),
                    onPressed: (){
                      helper.deleteContact(list[index].id);
                      setState(() {
                        list.removeAt(index);
                        Navigator.pop(context);
                      });
                    },
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
  void _showContactPage({Contact contact}) async{
    final recContact =  await Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage(contact: contact,)));

    if(recContact != null){
      if(contact !=null){
        await helper.updateContact(recContact);
      }else{
        await helper.saveContact(recContact);
      }
      _getAllContact();
    }
  }

  void _getAllContact(){
    helper.getAll().then((value){
      setState(() {
        list = value;
      });
    });
  }
}