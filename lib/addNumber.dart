import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_second/contactVo.dart';

class AddNumberForm extends StatefulWidget {
  final Function() onadd;
  const AddNumberForm({required this.onadd, super.key});

  @override
  _AddNumberFormState createState() => _AddNumberFormState();
}

class _AddNumberFormState extends State<AddNumberForm> {
  // API 엔드포인트 설정
  static const String apiEndpoint = "http://10.0.2.2:8099/api/user";

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedGroup = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("연락처 추가"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: '이름'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: '이메일'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: '전화번호'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: '주소'),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  TextButton(
                    child: Text("그룹"),
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
                  Text(_selectedGroup),
                ],
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _emailController.text.isNotEmpty &&
                      _phoneController.text.isNotEmpty &&
                      _addressController.text.isNotEmpty &&
                      _selectedGroup.isNotEmpty) {
                    _addContact(); // 리스트에 추가
                    // Navigator.pop(context); // 돌아가기
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

  //  연락처 추가 함수
  void _addContact() async {
    try {
      // 요청
      var dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      // Post 요청
      final response = await dio.post(
        apiEndpoint,
        data: {
          "name": _nameController.text,
          "email": _emailController.text,
          "phoneNumber": _phoneController.text,
          "address": _addressController.text,
          "group": _selectedGroup,
        },
      );

      // 응답
      if (response.statusCode == 200) {
        // ContactVo updatedContact = ContactVo.fromJson(response.data);

        widget.onadd();
        // 목록 페이지로
        Navigator.pop(context);
        // Navigator.pushNamed(context, "/");
      } else {
        throw Exception("할 일을 추가하지 못했습니다. ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("할 일을 추가하지 못했습니다: $e");
    }
  }
}
