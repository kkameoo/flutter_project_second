import 'package:flutter/material.dart';
import 'package:flutter_project_second/addNumber.dart';
import 'package:flutter_project_second/contact_detail.dart'; // 추가

class ListForm extends StatelessWidget {
  const ListForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: ContactListPage(),
    );
  }
}

class Contact {
  final String name;
  final String phone;
  Contact(this.name, this.phone);
}

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Contact> contacts = [
    Contact("김철수", "010-1234-5678"),
    Contact("이영희", "010-9876-5432"),
    Contact("박민수", "010-5555-1111"),
    Contact("최다혜", "010-2222-3333"),
    Contact("정호진", "010-7777-8888"),
  ];

  void _addContact(Contact contact) {
    setState(() {
      contacts.add(contact);
    });
  }

  void _editContact(Contact oldContact, Contact newContact) {
    setState(() {
      int index = contacts.indexOf(oldContact);
      if (index != -1) contacts[index] = newContact;
    });
  }

  void _deleteContact(Contact contact) {
    setState(() {
      contacts.remove(contact);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("전화번호부"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              contacts[index].name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              contacts[index].phone,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactDetailPage(
                    contact: contacts[index],
                    onEdit: (newContact) => _editContact(contacts[index], newContact),
                    onDelete: _deleteContact,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNumberForm(onAdd: _addContact),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}
