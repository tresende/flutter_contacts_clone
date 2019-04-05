import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts_clone/helpers/contact_helper.dart';
import 'package:flutter_contacts_clone/ui/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { ordemaz, ordemza }

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
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            onSelected: _orderList,
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar de A-Z"),
                    value: OrderOptions.ordemaz,
                  ),
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar de Z-A"),
                    value: OrderOptions.ordemza,
                  ),
                ],
          )
        ],
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
          this._showOptions(context, index);
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

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.ordemaz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.ordemza:
        contacts.sort((b, a) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: () {
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                        child: Text("Ligar",
                            style: TextStyle(color: Colors.red, fontSize: 20)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                        child: Text("Editar",
                            style: TextStyle(color: Colors.red, fontSize: 20)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            helper.deleteContact(contacts[index].id);
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Excluir",
                            style: TextStyle(color: Colors.red, fontSize: 20)),
                      ),
                    )
                  ],
                ),
              );
            },
            onClosing: () {},
          );
        });
  }
}
