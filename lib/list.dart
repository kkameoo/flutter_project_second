import 'package:flutter/material.dart';
import 'package:flutter_project_second/addNumber.dart';
import 'package:flutter_project_second/contact_detail.dart'; // 추가1
import 'package:dio/dio.dart'; // 추가
import 'package:flutter_project_second/contactVo.dart';

// 연락처 목록을 보여주는 페이지
class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  // API 엔드포인트 설정
  static const String apiEndpoint = "http://10.0.2.2:8099/api/user";
  String _selectedGroup = "전체"; // 기본값 "전체"

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

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _allContacts.where((contact) {
        final matchesQuery = contact.name.toLowerCase().contains(query) ||
            contact.phoneNumber.contains(query);
        final matchesGroup = _selectedGroup == "전체" || contact.group == _selectedGroup;
        return matchesQuery && matchesGroup;
      }).toList();
    });
  }

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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("데이터를 불러오는데 실패 했습니다: \${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return Center(child: Text("할 일이 없습니다."));
        } else {
          _allContacts = snapshot.data!;
          _filteredContacts = _searchController.text.isEmpty && _selectedGroup == "전체"
              ? _allContacts
              : _allContacts.where((contact) {
            final query = _searchController.text.toLowerCase();
            final matchesQuery = contact.name.toLowerCase().contains(query) ||
                contact.phoneNumber.contains(query);
            final matchesGroup = _selectedGroup == "전체" || contact.group == _selectedGroup;
            return matchesQuery && matchesGroup;
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          contact.phoneNumber,
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
                                contact: contact,
                                onEdit: () {
                                  _updateState();
                                  Navigator.pop(context);
                                },
                                onDelete: () {
                                  _updateState();
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
                Column(
                  children: [
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
                                  _buildMenuItem(context, "전체"),
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
                    Text("선택된 그룹: \$_selectedGroup"),
                  ],
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNumberForm(
                      onadd: () {
                        _updateState();
                      },
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.orangeAccent,
            ),
          );
        }
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, String label) {
    return ListTile(
      title: Text(label),
      onTap: () {
        setState(() {
          _selectedGroup = label;
        });
        _filterContacts();
        Navigator.pop(context);
      },
    );
  }

  Future<List<ContactVo>> getContactList() async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = "application/json";

      final response = await dio.get(apiEndpoint);

      if (response.statusCode == 200) {
        List<ContactVo> loadedContacts = [];
        for (int i = 0; i < response.data.length; i++) {
          ContactVo contactItem = ContactVo.fromJson(response.data[i]);
          loadedContacts.add(contactItem);
        }
        return loadedContacts;
      } else {
        throw Exception("API 서버 오류");
      }
    } catch (e) {
      print("연락처 데이터를 불러오는데 실패했습니다: \$e");
      return [];
    }
  }

  void _updateState() {
    setState(() {
      contactListFuture = getContactList();
    });
  }
}
