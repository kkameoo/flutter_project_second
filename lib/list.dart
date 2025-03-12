import 'package:flutter/material.dart';
import 'package:flutter_project_second/addNumber.dart';

import 'package:flutter_project_second/contact_detail.dart'; // 추가1
import 'package:dio/dio.dart'; // 추가
import 'package:flutter_project_second/contactVo.dart';

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

// 연락처 목록을 보여주는 페이지
class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  // API 엔드포인트 설정
  static const String apiEndpoint = "http://10.0.2.2:8099/api/user";

  // List<Contact> contacts = []; //  연락처 리스트
  late Future<List<ContactVo>> contactListFuture;
  List<ContactVo> _allContacts = []; // 전체 연락처
  List<ContactVo> _filteredContacts = []; // 필터링된 연락처

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterContacts);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contactListFuture = getContactList(); // 서버로부터 데이터 수신
  }
  //추가
  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _allContacts.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
            contact.phoneNumber.contains(query);
      }).toList();
    });
  }

  //추가
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: contactListFuture,
      builder: (context, snapshot) {
        print("snapshot: $snapshot");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("데이터를 불러오는데 실패 했습니다: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return Center(child: Text("할 일이 없습니다."));
        } else {
          _allContacts = snapshot.data!;
          _filteredContacts = _searchController.text.isEmpty
              ? _allContacts
              : _allContacts.where((contact) {
            final query = _searchController.text.toLowerCase();
            return contact.name.toLowerCase().contains(query) ||
                contact.phoneNumber.contains(query);
          }).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("전화번호부"),
              backgroundColor: Colors.orangeAccent,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "검색 (이름 또는 전화번호)",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      return ListTile(
                        title: Text(
                          contact.name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          contact.phoneNumber,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContactDetailPage(
                                contact: contact,
                                onEdit: (editedContact) {
                                  setState(() {
                                    contactListFuture = getContactList();
                                  });
                                  Navigator.pop(context);
                                },
                                onDelete: (deletedContact) {
                                  setState(() {
                                    contactListFuture = getContactList();
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                //  연락처 추가 페이지로 이동
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => AddNumberForm(onAdd: _addContact),
                //   ),
                // );
              },
              child: Icon(Icons.add), //  연락처 추가 버튼
              backgroundColor: Colors.orangeAccent,
            ),
          );
        }
      },
    );
  }

  //  API에서 연락처 목록을 가져오는 함수
  Future<List<ContactVo>> getContactList() async {
    try {
      var dio = Dio(); //  Dio 인스턴스 생성 (HTTP 요청을 위해 사용)
      dio.options.headers['Content-Type'] =
          "application/json"; //  JSON 형식으로 데이터 주고받기 설정

      final response = await dio.get(apiEndpoint); //  서버에 GET 요청 보내기

      if (response.statusCode == 200) {
        print(response.data); //  API 응답 데이터 출력 (디버깅용)

        //  JSON 데이터를 Contact 리스트로 변환
        List<ContactVo> loadedContacts = [];
        for (int i = 0; i < response.data.length; i++) {
          // (response.data as List)
          //     .map((data) => ContactVo.fromJson(response.data[i]))
          //     .toList();
          //  개별 아이템 받아오기
          ContactVo contactItem = ContactVo.fromJson(response.data[i]);
          // 목록에 추가
          loadedContacts.add(contactItem);
        }

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
  void _addContact() {
    // setState(() {
    //    ContactVo.add(contact);
    // });
  }

  //  연락처 수정 함수
  void _editContact() {}

  //  연락처 삭제 함수
  void _deleteContact() {}
}
