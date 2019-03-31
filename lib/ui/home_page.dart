import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts_clone/helpers/contact_helper.dart';
import 'package:flutter_contacts_clone/ui/contact_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List<Contact>();

  @override
  void initState() {
    super.initState();
    // Contact contact = Contact();
    // contact.name = 'Thiago';
    // contact.email = 'thiago.gcresende@gmail.com';
    // contact.phone = '+55(99)9-9999-9999';
    // contact.img = 'teste.png';
    // this.helper.saveContact(contact);
    this.getAllContacts();
  }

  void getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        this.contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          this._showContactPage();
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return contactCard(context, index);
        },
        itemCount: this.contacts.length,
        padding: EdgeInsets.all(10),
      ),
    );
  }

  Widget contactCard(BuildContext context, int index) {
    Contact contact = contacts[index];
    return GestureDetector(
        onTap: () {
          this._showContactPage(contact: contact);
        },
        child: Card(
            child: Padding(
          child: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contact.img != null
                            ? FileImage(File(contact.img))
                            : AssetImage('images/person.png'))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contact.name ?? "",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contact.email ?? "",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      contact.phone ?? "",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
          padding: EdgeInsets.all(10),
        )));
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
    }
    this.getAllContacts();
  }
}
