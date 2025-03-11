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

// 연락처 목록을 보여주는 페이지
class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  // API 엔드포인트 설정
  static const String apiEndpoint = "http://10.0.2.2:8099/api/user";

  List<Contact> contacts = []; //  연락처 리스트

  @override
  void initState() {
    super.initState();
    loadContacts(); //  앱 실행 시 API에서 연락처 목록 불러오기
  }

  //  API에서 연락처 목록을 불러와 화면에 적용하는 함수
  Future<void> loadContacts() async {
    List<Contact> fetchedContacts =
        await getContactList(); //  API에서 연락처 데이터 가져오기
    setState(() {
      contacts = fetchedContacts; //  가져온 데이터로 리스트 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("전화번호부"),
        backgroundColor: Colors.orangeAccent,
      ),
      body:
          contacts.isEmpty
              ? Center(child: CircularProgressIndicator()) //  데이터 로딩 중 표시
              : ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      contacts[index].name, //  연락처 이름 표시
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      contacts[index].phoneNumber, //  연락처 전화번호 표시
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    onTap: () {
                      //  연락처 클릭 시 상세 정보 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ContactDetailPage(
                                contact: contacts[index],
                                onEdit:
                                    (newContact) => _editContact(
                                      contacts[index],
                                      newContact,
                                    ),
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
          //  연락처 추가 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNumberForm(onAdd: _addContact),
            ),
          );
        },
        child: Icon(Icons.add), //  연락처 추가 버튼
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }

  //  API에서 연락처 목록을 가져오는 함수
  Future<List<Contact>> getContactList() async {
    try {
      var dio = Dio(); //  Dio 인스턴스 생성 (HTTP 요청을 위해 사용)
      dio.options.headers['Content-Type'] =
          "application/json"; //  JSON 형식으로 데이터 주고받기 설정

      final response = await dio.get(apiEndpoint); //  서버에 GET 요청 보내기

      if (response.statusCode == 200) {
        print(response.data); //  API 응답 데이터 출력 (디버깅용)

        //  JSON 데이터를 Contact 리스트로 변환
        List<Contact> loadedContacts =
            (response.data as List)
                .map((data) => Contact.fromJson(data))
                .toList();

        return loadedContacts; //  연락처 리스트 반환
      } else {
        throw Exception("API 서버 오류");
      }
    } catch (e) {
      print("연락처 데이터를 불러오는데 실패했습니다: $e");
      return []; //  오류 발생 시 빈 리스트 반환
    }
  }

  //  연락처 추가 함수
  void _addContact(Contact contact) {
    setState(() {
      contacts.add(contact);
    });
  }

  //  연락처 수정 함수
  void _editContact(Contact oldContact, Contact newContact) {
    setState(() {
      int index = contacts.indexOf(oldContact);
      if (index != -1) contacts[index] = newContact;
    });
  }

  //  연락처 삭제 함수
  void _deleteContact(Contact contact) {
    setState(() {
      contacts.remove(contact);
    });
  }
}
