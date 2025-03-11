import 'package:flutter/material.dart';

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
                  builder:
                      (context) => ContactDetailPage(contact: contacts[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 새 연락처 추가 기능
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}

class ContactDetailPage extends StatelessWidget {
  final Contact contact;
  ContactDetailPage({required this.contact});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("연락처 상세"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "이름: ${contact.name}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("전화번호: ${contact.phone}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
