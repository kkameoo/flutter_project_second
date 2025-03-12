import 'package:flutter/material.dart';

class HomeForm extends StatelessWidget {
  const HomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("홈"),
        backgroundColor:  Colors.orangeAccent,
      ),
      body: _HomeForm(),
    );
  }
}

class _HomeForm extends StatefulWidget {
  const _HomeForm({super.key});

  @override
  State<_HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<_HomeForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 위쪽과 아래쪽에 공간을 자동으로 배분
        children: [
          // 화면 상단에 이미지를 넣으려면, Container로 감싸서 크기를 설정합니다.
          Container(
            height: 555,  // 이미지 높이를 설정 (필요한 크기로 변경)
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bear.jpg'),  // 이미지 경로
                fit: BoxFit.cover,  // 이미지를 컨테이너에 맞게 꽉 채움
              ),
            ),
          ),

          Expanded(child: Container()),  // 화면 상단의 여백을 만들어줍니다.
          // 버튼을 화면 하단에 배치
          Row(
            mainAxisAlignment: MainAxisAlignment.center,  // 버튼을 중앙 정렬
            children: [
              Container(
                width: 200,  // 네모의 가로 크기
                height: 200,  // 네모의 세로 크기
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/call.jpg'),  // 다른 이미지 경로
                    fit: BoxFit.cover,  // 이미지를 네모 상자에 맞게 꽉 채움
                  ),
                  // image: DecorationImage(
                  //   image: AssetImage('../android/img/다운로드.jpg'),  // 이미지 경로
                  //   fit: BoxFit.cover,  // 이미지를 네모 상자에 맞게 꽉 채움
                  // ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/list");
                  },
                ),
              ),
              SizedBox(width: 10),  // 두 버튼 사이의 간격
              Container(
                width: 200,  // 네모의 가로 크기
                height: 200,  // 네모의 세로 크기
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/call2.jpg'),  // 다른 이미지 경로
                    fit: BoxFit.cover,  // 이미지를 네모 상자에 맞게 꽉 채움
                  ),

                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/remove");
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





