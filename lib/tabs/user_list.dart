import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_app/models/user_model.dart';
import 'package:wordpress_app/tabs/chat.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List').tr(),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("Users").get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            // List<UserModel> userM = UserModel.fromQuerySnapshot(snapshot.data!);
            return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Container(
                // height: 20.0,
                // color: Colors.lightGreen,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: ListTile(
                  onTap: () {
                    UserModel user = UserModel(
                        uid: data['uid'],
                        userName: data['userName'],
                        userEmail: data['email']);
                    print(user.uid);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Chat(user: user);
                    }));
                  },
                  title: Text(data['userName']),
                  subtitle: Text(data['email']),
                ),
              );
            }).toList());
          }

          return Text("loading");
        },
      ),
    );
  }
}
