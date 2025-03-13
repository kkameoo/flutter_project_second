import 'package:dio/dio.dart';

class MemoController {
  static const String apiBaseUrl = "http://10.0.2.2:8099/api/memo";

  // 특정 연락처의 메모 불러오기
  static Future<String> getMemo(int userId) async {
    try {
      var dio = Dio();
      String url = "$apiBaseUrl/$userId";

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data['content'] ?? ""; // 메모 내용 반환
      } else {
        throw Exception("메모 조회 실패");
      }
    } catch (e) {
      print("메모 불러오기 오류: $e");
      return ""; // 오류 발생 시 빈 문자열 반환
    }
  }
}
