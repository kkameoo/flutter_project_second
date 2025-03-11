import 'package:flutter/material.dart';
import 'package:flutter_project_second/addNumber.dart';
import 'package:flutter_project_second/contact_detail.dart'; // 추가1
import 'package:dio/dio.dart'; // 추가

// class ListForm extends StatelessWidget {
//   const ListForm({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.orange),
//       home: ContactListPage(),
//     );
//   }
// }

class Contact {
  final String name;
  final String phoneNumber;

  Contact({required this.name, required this.phoneNumber});

  // JSON 데이터를 Contact 객체로 변환
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(name: json['name'], phoneNumber: json['phone_number']);
  }
}

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    fetchContacts(); // 앱 실행 시 API에서 데이터 불러오기
  }

  Future<void> fetchContacts() async {
    try {
      var response = await Dio().get("http://localhost:8099/api/user");

      // JSON 리스트 데이터를 Contact 리스트로 변환
      List<Contact> loadedContacts = (response.data as List)
          .map((data) => Contact.fromJson(data))
          .toList();

      setState(() {
        contacts = loadedContacts; // 가져온 데이터로 리스트 업데이트
      });
    } catch (e) {
      print("데이터 불러오기 실패: $e");
    }
  }

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
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator()) // 데이터 로딩 중
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              contacts[index].name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              contacts[index].phoneNumber,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactDetailPage(
                    contact: contacts[index],
                    onEdit: (newContact) =>
                        _editContact(contacts[index], newContact),
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
