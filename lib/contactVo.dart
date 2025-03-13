class ContactVo {
  int userId;
  String name;
  String email;
  String phoneNumber;
  String address;
  String group;
  bool isFavorite;
  int clickCount; // 클릭 횟수 이벤트

  ContactVo({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.group,
    this.isFavorite = false, // 기본값 false
    this.clickCount = 0,
  });

  // JSON 데이터를 ContactVo 객체로 변환
  factory ContactVo.fromJson(Map<String, dynamic> apiData) {
    return ContactVo(
      userId: apiData['userId'],
      name: apiData['name'],
      email: apiData['email'],
      phoneNumber: apiData['phoneNumber'],
      address: apiData['address'],
      group: apiData['group'],
      isFavorite: apiData['isFavorite'] ?? false, // 추가
      clickCount: apiData['count'] ?? 0,
    );
  }

  // ContactVo 객체를 JSON(Map)으로 변환
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'group': group,
      'isFavorite': isFavorite, // 추가
      'count': clickCount,
    };
  }
}
