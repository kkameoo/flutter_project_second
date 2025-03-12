import 'package:flutter/material.dart';
import 'package:flutter_project_second/contactVo.dart';
import 'list.dart';

class ContactDetailPage extends StatelessWidget {
  final ContactVo contact;
  final Function(ContactVo) onEdit;
  final Function(ContactVo) onDelete;

  ContactDetailPage({
    required this.contact,
    required this.onEdit,
    required this.onDelete,
  });

  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editPhoneController = TextEditingController();

  void _showEditDialog(BuildContext context) {
    _editNameController.text = contact.name;
    _editPhoneController.text = contact.phoneNumber;

    showDialog(
      context: context,
      builder:
          (contextEdit) => AlertDialog(
            title: Text("연락처 수정"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _editNameController,
                  decoration: InputDecoration(labelText: "이름"),
                ),
                TextField(
                  controller: _editPhoneController,
                  decoration: InputDecoration(labelText: "전화번호"),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("취소"),
                onPressed: () => Navigator.pop(contextEdit),
              ),
              ElevatedButton(
                child: Text("수정"),
                onPressed: () {
                  // final updatedContact = ContactVo(
                  //   name: _editNameController.text,
                  //   phoneNumber: _editPhoneController.text,
                  // );
                  // onEdit(updatedContact);
                  // Navigator.pop(contextEdit); // 다이얼로그 닫기
                  // Navigator.pop(context); // 상세 페이지 닫기 -> 리스트로 이동
                },
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (contextDelete) => AlertDialog(
            title: Text("삭제 확인"),
            content: Text("${contact.name}을(를) 삭제하시겠습니까?"),
            actions: [
              TextButton(
                child: Text("취소"),
                onPressed: () => Navigator.pop(contextDelete),
              ),
              ElevatedButton(
                child: Text("삭제"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  onDelete(contact);
                  Navigator.pop(contextDelete); // 다이얼로그 닫기
                  Navigator.pop(context); // 상세 페이지 닫기 -> 리스트로 이동
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("연락처 상세"),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteConfirm(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("이름: ${contact.name}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(
              "전화번호: ${contact.phoneNumber}",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
