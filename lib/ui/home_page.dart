import 'package:flutter/material.dart';
import 'package:flutter_contacts_clone/helpers/contact_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  // @override
  // void initState() {
  //   super.initState();
  //   Contact contact = Contact();
  //   contact.name = 'Thiago';
  //   contact.email = 'thiago.gcresende@gmail.com';
  //   contact.phone = '+55(99)9-9999-9999';
  //   contact.img = 'teste.png';
  //   this.helper.saveContact(contact);

  //   helper.getAllContacts().then((list) {
  //     print(list);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
