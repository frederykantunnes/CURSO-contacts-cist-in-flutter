import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_contacts_agend/helpers/ContactHelper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _userEdited = false;
  Contact _editedContac;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.contact == null){
      _editedContac = Contact();
    }else{
      _editedContac = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContac.name;
      _emailController.text = _editedContac.email;
      _phoneController.text = _editedContac.phone;
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        _requestPop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContac.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
          onPressed: (){
            if(_editedContac.name.isNotEmpty){
              Navigator.pop(context, _editedContac);
            }
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file ==null){
                    }else{
                      setState(() {
                        _editedContac.image = file.path;
                      });
                    }
                  });
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContac.image != null ? FileImage(File(_editedContac.image)) : AssetImage("images/person.png")
                      )
                  ),
                ),
              ),
              TextField(
                controller: _nameController,
                onChanged: (text){
                  if(_editedContac.name != text){
                    _userEdited = true;
                    setState(() {
                      _editedContac.name = text;
                    });
                  }
                },
                decoration: InputDecoration(
                    labelText: "Nome"
                ),
              ),
              TextField(
                controller: _emailController,
                onChanged: (text){
                  if(_editedContac.email != text){
                    _userEdited = true;
                    _editedContac.email = text;
                  }
                },
                decoration: InputDecoration(
                    labelText: "Email"
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                onChanged: (text){
                  if(_editedContac.phone != text){
                    _userEdited = true;
                    _editedContac.phone = text;
                  }
                },
                decoration: InputDecoration(
                    labelText: "Telefone"
                ),
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Descartar Alterações?"),
          content: Text("Se sair as alterações serão perdidas."),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Sim"),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }
}
