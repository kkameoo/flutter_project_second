class ContactVo {
  int userId;
  String name;
  String email;
  String phoneNumber;
  String address;
  String group;

  ContactVo({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.group,
  });

  // JSON 데이터를 Contact 객체로 변환
  factory ContactVo.fromJson(Map<String, dynamic> apiData) {
    return ContactVo(
      userId: apiData['userId'],
      name: apiData['name'],
      email: apiData['email'],
      phoneNumber: apiData['phoneNumber'],
      address: apiData['address'],
      group: apiData['group'],
    );
  }

  // 현재 TodoItemVo 객체를 Map 형식으로 내보내는 메서드
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'group': group,
    };
  }
}
