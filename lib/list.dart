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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contactListFuture = getContactList(); // 서버로부터 데이터 수신
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
          return Scaffold(
            appBar: AppBar(
              title: Text("전화번호부"),
              backgroundColor: Colors.orangeAccent,
            ),
            body:
                snapshot.data!.isEmpty
                    ? Center(child: CircularProgressIndicator()) //  데이터 로딩 중 표시
                    : ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            snapshot.data![index].name, //  연락처 이름 표시
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data![index].phoneNumber, //  연락처 전화번호 표시
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactDetailPage(
                                  contact: snapshot.data![index],
                                  onEdit: (editedContact) {
                                    // 수정 완료 시 리스트 갱신
                                    setState(() {
                                      contactListFuture = getContactList();
                                    });
                                    Navigator.pop(context); // 리스트로 복귀
                                  },
                                  onDelete: (deletedContact) {
                                    // 삭제 완료 시 리스트 갱신
                                    setState(() {
                                      contactListFuture = getContactList();
                                    });
                                    Navigator.pop(context); // 리스트로 복귀
                                  },
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
