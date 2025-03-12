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
}
