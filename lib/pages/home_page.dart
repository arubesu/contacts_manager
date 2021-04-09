import 'dart:io';
import 'package:contacts_manager/helpers/contacts_helper.dart';
import 'package:contacts_manager/models/contact.dart';
import 'package:contacts_manager/pages/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var contactDAO = ContactHelper();

  List<Contact> contacts = [];

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
          itemCount: contacts.length, //contacts.length,
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
                                image: contacts[index].img != null
                                    ? FileImage(File(contacts[index].img))
                                    : AssetImage("images/profile.png")))),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            contacts[index].name ?? "",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            contacts[index].email ?? "",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            contacts[index].phone ?? "",
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
          _showContactPage(contact: contacts[index]);
        });
  }

  void _showContactPage({Contact contact}) async {
    var _editedContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));

    if (_editedContact != null) {
      await contactDAO.saveOrUpdateContact(_editedContact);
    }
    _getAllContacts();
  }

  void _getAllContacts() {
    contactDAO.getContacts().then((contactsResult) => {
          setState(() {
            contacts = contactsResult;
          })
        });
  }
}
