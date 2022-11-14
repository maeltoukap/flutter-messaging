import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userName;
  final String? userEmail;
  final String? uid;
  final int? id;

  UserModel({
    this.userName,
    this.userEmail,
    this.uid,
    this.id,
  });

  static List<UserModel> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    List<UserModel> users = [];
    for (final doc in querySnapshot.docs) {
      print(doc['sendDateTime']);
      final user = UserModel(
        userName: doc['userName'],
        userEmail: doc['email'],
        uid: doc['uid'],
      );
      users.add(user);
    }
    return users;
  }
  static UserModel fromDocumentSnapshot(DocumentSnapshot querySnapshot) {
    // UserModel users;
    // for (final doc in querySnapshot.docs) {
      // print(querySnapshot['sendDateTime']);
      final user = UserModel(
        userName: querySnapshot['userName'],
        userEmail: querySnapshot['email'],
        uid: querySnapshot['uid'],
      );
      // users.add(user);
    // }
    return user;
  }
}
