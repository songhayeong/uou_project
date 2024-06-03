import 'package:detail_location_detector/domain/auth/entity/userAndSensor.dart';

class Group {
  final String groupId;
  final List<UserAndSensor> membersData;

  Group({
    required this.groupId,
    required this.membersData,
  });

  factory Group.fromMap(Map<String, dynamic> json) {
    var membersList = json['members'] as List<dynamic>;
    var membersData = membersList.map((member) => UserAndSensor.fromMap(member as Map<String, dynamic>)).toList();

    return Group(
      groupId: json['id'],
      membersData: membersData,
    );
  }
}

// Future<void> _dialogBuilder(BuildContext context) {
// // 현재 화면 위에 보여줄 다이얼로그 생성
//   return showDialog<void>(
//     context: context,
//     builder: (context) {
//       // 빌더로 AlertDialog 위젯을 생성
//       return AlertDialog(
//         title: const Text('실내외 여부 : 실내'),
//         content: const Text('울산대학교 대학회관 - 층수 : 1층'),
//         actions: [
//           // 다이얼로그 내의 취소 버튼 터치 시 다이얼로그 화면 제거
//           OutlinedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('확인'),
//           ),
//         ],
//       );
//     },
//   );
