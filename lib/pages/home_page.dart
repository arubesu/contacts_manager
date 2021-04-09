import 'dart:io';
import 'package:contacts_manager/helpers/contacts_helper.dart';
import 'package:contacts_manager/models/contact.dart';
import 'package:contacts_manager/pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _contactDAO = ContactHelper();

  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          onPressed: _showContactPage,
          backgroundColor: Colors.red,
          child: Icon(Icons.add)),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: _contacts.length, //contacts.length,
          itemBuilder: (context, index) {
            return _contactCardBuilder(context, index);
          }),
    );
  }

  Widget _contactCardBuilder(BuildContext context, int index) {
    return GestureDetector(
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
                                image: _contacts[index].img != null
                                    ? FileImage(File(_contacts[index].img))
                                    : AssetImage("images/profile.png")))),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _contacts[index].name ?? "",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _contacts[index].email ?? "",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            _contacts[index].phone ?? "",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ))),
        onTap: () {
          _showContactActions(context, index);
        });
  }

  void _showContactActions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () => Navigator.pop(context),
              builder: (context) {
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: TextButton(
                                child: Text(
                                  "Call",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  launch("tel:${_contacts[index].phone}");
                                })),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: TextButton(
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showContactPage(contact: _contacts[index]);
                                })),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: TextButton(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _contactDAO
                                        .deleteContact(_contacts[index].id);
                                    _contacts.removeAt(index);
                                  });
                                })),
                      ],
                    ));
              });
        });
  }

  void _showContactPage({Contact contact}) async {
    var _editedContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));

    if (_editedContact != null) {
      await _contactDAO.saveOrUpdateContact(_editedContact);
    }
    _getAllContacts();
  }

  void _getAllContacts() {
    _contactDAO.getContacts().then((contactsResult) => {
          setState(() {
            _contacts = contactsResult;
          })
        });
  }
}
