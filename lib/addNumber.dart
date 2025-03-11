import 'package:flutter/material.dart';
import 'list.dart';

class AddNumberForm extends StatefulWidget {
  final Function(Contact) onAdd;

  const AddNumberForm({required this.onAdd, super.key});

  @override
  _AddNumberFormState createState() => _AddNumberFormState();
}

class _AddNumberFormState extends State<AddNumberForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("연락처 추가"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: '전화번호'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _phoneController.text.isNotEmpty) {
                  final newContact = Contact(
                    name: _nameController.text,
                    phoneNumber: _phoneController.text,
                  );
                  widget.onAdd(newContact); // 리스트에 추가
                  Navigator.pop(context);  // 돌아가기
                }
              },
              child: Text("추가하기"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
