import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts_clone/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();


  Contact _editedContact;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if ( _editedContact.name != null && _editedContact.name.isNotEmpty) {
            Navigator.pop(context, _editedContact);
          } else {
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            GestureDetector(
                child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _editedContact.img != null
                          ? FileImage(File(_editedContact.img))
                          : AssetImage('images/person.png'))),
            )),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              onChanged: (text) {
                setState(() {
                  this._userEdited = true;
                  this._editedContact.name = text;
                });
              },
              decoration: InputDecoration(
                labelText: 'Nome',
              ),
            ),
            TextField(
              controller: _emailController,
              onChanged: (text) {
                this._userEdited = true;
                this._editedContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (text) {
                this._userEdited = true;
                this._editedContact.phone = text;
              },
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            )
          ],
        ),
      ),
    );
  }
}
