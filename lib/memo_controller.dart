import 'package:dio/dio.dart';

class MemoController {
  static const String apiBaseUrl = "http://10.0.2.2:8099/api/memo";

  // 특정 연락처의 메모 불러오기
  static Future<dynamic> getMemo(int userId) async {
    try {
      var dio = Dio();
      String url = "$apiBaseUrl/$userId";

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("메모 조회 실패");
      }
    } catch (e) {
      print("메모 불러오기 오류: $e");
      return false; // 오류 발생 시 빈 문자열 반환
    }
  }

  // 특정 연락처의 메모 불러오기
  static Future<String> getMemoContent(int userId) async {
    try {
      var dio = Dio();
      String url = "$apiBaseUrl/$userId";

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        // print(response.data);
        return response.data['content'] ?? ""; // 메모 내용 반환
      } else {
        throw Exception("메모 조회 실패");
      }
    } catch (e) {
      print("메모 불러오기 오류: $e");
      return ""; // 오류 발생 시 빈 문자열 반환
    }
  }

  static Future<String> getMemoTitle(int userId) async {
    try {
      var dio = Dio();
      String url = "$apiBaseUrl/$userId";

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        // print(response.data['content']);
        return response.data['title'] ?? ""; // 메모 내용 반환
      } else {
        throw Exception("메모 조회 실패");
      }
    } catch (e) {
      print("메모 불러오기 오류: $e");
      return ""; // 오류 발생 시 빈 문자열 반환
    }
  }

  //  연락처 추가 함수
  static void addMemo(String title, String content, int userId) async {
    try {
      // 요청
      var dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      // Post 요청
      final response = await dio.post(
        apiBaseUrl,
        data: {"title": title, "content": content, "userId": userId},
      );

      // 응답
      if (response.statusCode == 200) {
        print("입력 성공");
      } else {
        throw Exception("할 일을 추가하지 못했습니다. ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("할 일을 추가하지 못했습니다: $e");
    }
  }
}
