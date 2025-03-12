import 'package:flutter/material.dart';
import 'package:flutter_project_second/contactVo.dart';
import 'package:dio/dio.dart';
import 'list.dart';

class ContactDetailPage extends StatelessWidget {
  final ContactVo contact; // 현재 선택된 연락처 정보
  final Function(ContactVo) onEdit; // 수정된 데이터를 리스트에 반영
  final Function(ContactVo) onDelete;

  ContactDetailPage({
    required this.contact,
    required this.onEdit,
    required this.onDelete,
  });

  // 수정 입력 필드를 위한 컨트롤러
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editPhoneController = TextEditingController();
  final TextEditingController _editEmailController = TextEditingController();
  final TextEditingController _editAdressController = TextEditingController();
  final TextEditingController _editGroupontroller = TextEditingController();

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
            Text("이메일: ${contact.email}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
              "전화번호: ${contact.phoneNumber}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text("주소: ${contact.address}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("그룹: ${contact.group}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    _editNameController.text = contact.name;
    _editPhoneController.text = contact.phoneNumber;
    _editEmailController.text = contact.email;
    _editAdressController.text = contact.address;
    _editGroupontroller.text = contact.group;

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
                TextField(
                  controller: _editEmailController,
                  decoration: InputDecoration(labelText: "이메일"),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _editAdressController,
                  decoration: InputDecoration(labelText: "주소"),
                ),
                TextField(
                  controller: _editPhoneController,
                  decoration: InputDecoration(labelText: "그룹"),
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
                onPressed: () async {
                  await _updateContact(context); // API 호출 후 수정 반영
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
                onPressed: () async {
                  _deleteContact(context);
                },
              ),
            ],
          ),
    );
  }

  Future<void> _updateContact(BuildContext context) async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';

      String apiUrl = "http://10.0.2.2:8099/api/user/${contact.userId}";

      Map<String, dynamic> updatedData = {
        "userId": contact.userId,
        "name": _editNameController.text,
        "phoneNumber": _editPhoneController.text,
        "email": _editEmailController.text,
        "address": _editAdressController.text,
        "group": _editGroupontroller.text,
      };

      // 서버에 PUT 요청 보내기
      final response = await dio.put(apiUrl, data: updatedData);

      if (response.statusCode == 200) {
        // 서버 응답이 정상이면 ui업데이트
        ContactVo updatedContact = ContactVo.fromJson(response.data);
        onEdit(updatedContact); //  리스트에서 데이터 변경 반영
        // Navigator.pop(context);
        Navigator.pop(context);
      } else {
        throw Exception("API 수정 요청 실패");
      }
    } catch (e) {
      print("연락처 수정 실패욤: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("수정에 실패했습니다. 다시 시도해주세요")));
    }
  }

  void _deleteContact(BuildContext context) async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';

      String apiUrl = "http://10.0.2.2:8099/api/user/${contact.userId}";

      //  서버에서 DELETE 요청 보내기
      final response = await dio.delete(apiUrl);

      if (response.statusCode == 200) {
        onDelete(contact); // 리스트에서 삭제 반영
        Navigator.pop(context);
      } else {
        throw Exception("API 삭제 요청 실패");
      }
    } catch (e) {
      print("연락처 삭제 실패: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("삭제에 실패했습니다. 다시 시도해주세욤")));
    }
  }
}
