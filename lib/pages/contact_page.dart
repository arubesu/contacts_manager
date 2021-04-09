import 'dart:io';

import 'package:contacts_manager/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  var _nameFocus = FocusNode();
  bool _isContactEdited;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
      return;
    }
    _isContactEdited = false;
    _editedContact = Contact.fromMap(widget.contact.toMap());
    _nameController.text = _editedContact.name;
    _emailController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _alertContactEdited,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? 'New Contact'),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact.name != null &&
                  _editedContact.name.isNotEmpty) {
                Navigator.pop(context, _editedContact);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  ImagePicker()
                      .getImage(source: ImageSource.camera)
                      .then((img) => {
                            if (img != null)
                              {
                                setState(() {
                                  _editedContact.img = img.path;
                                })
                              }
                          });
                },
                child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContact.img != null
                                ? FileImage(File(_editedContact.img))
                                : AssetImage("images/profile.png")))),
              ),
              TextField(
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: "Name"),
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    _isContactEdited = true;
                    setState(() {
                      _editedContact.name = text;
                    });
                  }),
              TextField(
                  decoration: InputDecoration(labelText: "Email"),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (text) {
                    _isContactEdited = true;
                    _editedContact.email = text;
                  }),
              TextField(
                  decoration: InputDecoration(labelText: "Phone"),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    _editedContact.phone = text;
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _alertContactEdited() {
    if (_isContactEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Your changes have not been saved"),
              actions: [
                TextButton(
                    child: Text("Discard"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: Text("Save"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context, _editedContact);
                    }),
              ],
            );
          });

      return Future.value(false);
    }

    return Future.value(true);
  }
}
