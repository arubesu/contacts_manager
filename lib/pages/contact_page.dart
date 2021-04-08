import 'dart:io';

import 'package:contacts_manager/models/contact.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;

  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _phoneController = TextEditingController();
  bool _userEdited;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
      return;
    }

    _editedContact = Contact.fromMap(widget.contact.toMap());
    _nameController.text = _editedContact.name;
    _emailController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedContact.name ?? 'New Contact'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.save),
          backgroundColor: Colors.red),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage("images/profile.png")))),
            TextField(
                decoration: InputDecoration(labelText: "Name"),
                controller: _nameController,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                }),
            TextField(
                decoration: InputDecoration(labelText: "Email"),
                controller: _emailController,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.email = text;
                }),
            TextField(
                decoration: InputDecoration(labelText: "Phone"),
                controller: _phoneController,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  _editedContact.phone = text;
                }),
          ],
        ),
      ),
    );
  }
}
