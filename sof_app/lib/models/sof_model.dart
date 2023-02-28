import 'package:sqflite/sqflite.dart';

class SOFModel {
  final int id;
  final String displayName;
  final String profileImage;
  final int reputation;
  final String location;
  final int age;

  SOFModel(
      {required this.id,
      required this.displayName,
      required this.profileImage,
      required this.reputation,
      required this.location,
      required this.age});

  factory SOFModel.fromMap(Map<String, dynamic> json) => SOFModel(
      id: json['id'],
      displayName: json['display_name'],
      profileImage: json['profile_image'],
      reputation: json['reputation'],
      location: json['location'],
      age: json['age']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'display_name': displayName,
      'profile_image': profileImage,
      'reputation': reputation,
      'location': location,
      'age': age
    };
  }

  static Future<dynamic> getBookmarkedUsers() async {
    var db = await openDatabase('bookmarked_database.db');
    var list = await db.query('bookmarked_users');
    return list;
  }

  static void addBookmarkUser(bookmarkUser) async {
    var db = await openDatabase('bookmarked_database.db');
    try {
      await db.insert('bookmarked_users', {
        'id': bookmarkUser['user_id'],
        'display_name': bookmarkUser['display_name'],
        'profile_image': bookmarkUser['profile_image'],
        'reputation': bookmarkUser['reputation'],
        'location': bookmarkUser['location'],
        'age': bookmarkUser['age'],
      });
      // await db.close();
    } catch (ex) {
      print(ex);
    }
  }

  static void removeBookMarkedUser(userid) async {
    var db = await openDatabase('bookmarked_database.db');
    try {
      await db.delete(
        'bookmarked_users', where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [userid],
      );
      // await db.close();
    } catch (ex) {
      print(ex);
    }
  }
}
