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
  static const String apiEndpoint = "http://10.0.2.2:8099/api/user";
  String _selectedGroup = "전체";

  late Future<List<ContactVo>> contactListFuture;
  List<ContactVo> _allContacts = [];
  List<ContactVo> _filteredContacts = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterContacts);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contactListFuture = getContactList();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts =
          _allContacts.where((contact) {
            final matchesQuery =
                contact.name.toLowerCase().contains(query) ||
                contact.phoneNumber.contains(query);
            final matchesGroup =
                _selectedGroup == "전체" || contact.group == _selectedGroup;
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
          return Center(child: Text("데이터를 불러오는데 실패 했습니다: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return Center(child: Text("할 일이 없습니다."));
        } else {
          _allContacts = snapshot.data!;
          _filteredContacts =
              _searchController.text.isEmpty && _selectedGroup == "전체"
                  ? _allContacts
                  : _allContacts.where((contact) {
                    final query = _searchController.text.toLowerCase();
                    final matchesQuery =
                        contact.name.toLowerCase().contains(query) ||
                        contact.phoneNumber.contains(query);
                    final matchesGroup =
                        _selectedGroup == "전체" ||
                        contact.group == _selectedGroup;
                    return matchesQuery && matchesGroup;
                  }).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("전화번호부"),
              backgroundColor: Colors.orangeAccent,
              actions: [
                IconButton(
                  icon: Icon(Icons.star, color: Colors.white),
                  onPressed: () {
                    showFavoriteContactsModal(context);
                  },
                ),
              ],
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
                        trailing: IconButton(
                          icon: Icon(
                            contact.isFavorite ? Icons.star : Icons.star_border,
                            color:
                                contact.isFavorite
                                    ? Colors.orange
                                    : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              contact.isFavorite = !contact.isFavorite;
                            });
                          },
                        ),
                        onTap: () {
                          _updateCount(contact.userId);
                          setState(() {
                            contact.clickCount++; // 클릭 횟수 증가
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ContactDetailPage(
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
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AddNumberForm(
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

  void showFavoriteContactsModal(BuildContext context) {
    for (int i = 0; i < _allContacts.length; i++) {
      print(_allContacts[i].toJson());
    }

    // 즐겨찾기 상태를 변경한 후, 전체 연락처 목록을 업데이트하기 위해 setState를 호출
    final favoriteContacts =
        _allContacts.where((contact) => contact.isFavorite).toList();

    // 클릭 횟수를 기준으로 내림차순 정렬 (자주 클릭한 순서대로)
    favoriteContacts.sort((a, b) => b.clickCount.compareTo(a.clickCount));

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Container(
              padding: EdgeInsets.all(10),
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "즐겨찾는 연락처",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child:
                        favoriteContacts.isEmpty
                            ? Center(child: Text("즐겨찾는 연락처가 없습니다."))
                            : ListView.builder(
                              itemCount: favoriteContacts.length,
                              itemBuilder: (context, index) {
                                final contact = favoriteContacts[index];
                                return ListTile(
                                  title: Text(contact.name),
                                  subtitle: Text(contact.phoneNumber),
                                  onTap: () {
                                    _updateCount(contact.userId);
                                    setState(() {
                                      contact.clickCount++; // 클릭 횟수 증가
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ContactDetailPage(
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
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        contact.isFavorite = false;
                                      });
                                      // 상태 변경 후, 전체 목록을 갱신하기 위해 setState 호출
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            );
          },
        );
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
      print("연락처 데이터를 불러오는데 실패했습니다: $e");
      return [];
    }
  }

  Future<void> _updateCount(int userId) async {
    try {
      var dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';

      String apiUrl = "http://10.0.2.2:8099/api/user/count/${userId}";

      // 서버에 PUT 요청 보내기
      final response = await dio.put(apiUrl);

      if (response.statusCode == 200) {
        // 서버 응답이 정상이면 ui업데이트

        print("ok");
      } else {
        throw Exception("API 수정 요청 실패");
      }
    } catch (e) {
      print("연락처 수정 실패욤: $e");
    }
  }

  void _updateState() {
    setState(() {
      contactListFuture = getContactList();
    });
  }
}
