import 'dart:convert';
import 'package:sof_app/constants/sof_user.dart';
import 'package:http/http.dart' as http;

class SOFs {
  static getSOFUsers(page) async {
    try {
      Uri api = Uri.parse('$kApiUrl?page=$page&pagesize=15&site=stackoverflow');
      final response = await http.get(api);
      if (response.statusCode == 200) {
        final users = jsonDecode(response.body);
        return users['items'];
      } else {
        throw Exception('Failed to load Users');
      }
    } catch (ex) {
      print(ex);
    }
  }

  static getUserReputage(userId, page) async {
    Uri api = Uri.parse(
        '$kApiUrl/$userId/reputation-history?page=$page&pagesize=15&site=stackoverflow');
    final response = await http.get(api);
    if (response.statusCode == 200) {
      final reputations = jsonDecode(response.body);
      return reputations['items'];
    } else {
      throw Exception('Failed to load Users');
    }
  }
}

// class Users {
//   final int userId;
//   final String userName;
//   final String userAvatar;
//   final String reputation;
//   final String location;
//   final String age;

//   const Users(
//       {required this.userId,
//       required this.userName,
//       required this.userAvatar,
//       required this.reputation,
//       required this.location,
//       required this.age});

//   factory Users.fromJson(Map<String, dynamic> data) {
//     return Users(
//       userId: data['userId'],
//       userName: data['userName'],
//       userAvatar: data['userAvatar'],
//       reputation: data['reputation'],
//       location: data['location'],
//       age: data['age'],
//     );
//   }
// }
