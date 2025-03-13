import 'package:flutter/material.dart';
import 'package:flutter_project_second/contactVo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project_second/memo_controller.dart';
import 'list.dart';

class ContactDetailPage extends StatefulWidget {
  // StatefulWidget으로 변경

  final ContactVo contact; // 현재 선택된 연락처 정보
  final Function() onEdit; // 수정된 데이터를 리스트에 반영
  final Function() onDelete;

  const ContactDetailPage({
    required this.contact,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  _ContactDetailPage createState() => _ContactDetailPage();
}

class _ContactDetailPage extends State<ContactDetailPage> {
  late String _selectedGroup = ""; // 초기 선택값
  final TextEditingController _memoController = TextEditingController(); //  메모 컨트롤러


  // 수정 입력 필드를 위한 컨트롤러
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editPhoneController = TextEditingController();
  final TextEditingController _editEmailController = TextEditingController();
  final TextEditingController _editAdressController = TextEditingController();
  final TextEditingController _editGroupontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE9ECEF),
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
          IconButton(
            icon: Icon(Icons.note), //
            onPressed: () => _showMemoDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 이름 박스
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "${widget.contact.name}",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 40),

            //  이메일, 전화번호, 주소의 박스
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "이메일: ${widget.contact.email}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "전화번호: ${widget.contact.phoneNumber}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "주소: ${widget.contact.address}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "그룹: ${widget.contact.group}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMemoDialog(BuildContext context) async {
    // 1️⃣ Spring Boot API에서 기존 메모 불러오기
    String existingMemo = await MemoController.getMemo(widget.contact.userId);

    // 2️⃣ 가져온 데이터를 TextField에 적용
    _memoController.text = existingMemo.isNotEmpty ? existingMemo : "메모가 없습니다.";

    // 3️⃣ 모달창 띄우기
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("메모"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _memoController,
              maxLines: 5,
              readOnly: true, // **읽기 전용**
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("닫기"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String label) {
    return ListTile(
      title: Text(label),
      onTap: () {
        setState(() {
          _selectedGroup = label; // 선택된 값을 업데이트
        });
        print("$_selectedGroup 선택됨"); // 선택된 메뉴 출력
        Navigator.pop(context); // 다이얼로그 닫기
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    _editNameController.text = widget.contact.name;
    _editPhoneController.text = widget.contact.phoneNumber;
    _editEmailController.text = widget.contact.email;
    _editAdressController.text = widget.contact.address;
    _selectedGroup = widget.contact.group;

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
                TextButton(
                  child: Text("그룹 선택"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("그룹 선택"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildMenuItem(context, "친구"),
                              _buildMenuItem(context, "친척"),
                              _buildMenuItem(context, "가족"),
                              _buildMenuItem(context, "직장"),
                              _buildMenuItem(context, "기타"),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                Text("선택된 그룹: $_selectedGroup"),
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
            content: Text("${widget.contact.name}을(를) 삭제하시겠습니까?"),
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

      String apiUrl = "http://10.0.2.2:8099/api/user/${widget.contact.userId}";

      Map<String, dynamic> updatedData = {
        "userId": widget.contact.userId,
        "name": _editNameController.text,
        "phoneNumber": _editPhoneController.text,
        "email": _editEmailController.text,
        "address": _editAdressController.text,
        "group": _selectedGroup,
      };

      // 서버에 PUT 요청 보내기
      final response = await dio.put(apiUrl, data: updatedData);

      if (response.statusCode == 200) {
        // 서버 응답이 정상이면 ui업데이트
        ContactVo updatedContact = ContactVo.fromJson(response.data);
        widget.onEdit(); //  리스트에서 데이터 변경 반영
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

      String apiUrl = "http://10.0.2.2:8099/api/user/${widget.contact.userId}";

      //  서버에서 DELETE 요청 보내기
      final response = await dio.delete(apiUrl);

      if (response.statusCode == 200) {
        widget.onDelete(); // 리스트에서 삭제 반영
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
