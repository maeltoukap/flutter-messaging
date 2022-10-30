import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_app/configs/configs.dart';
import 'package:wordpress_app/models/user_model.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/utils/message_bullet.dart';
import 'package:wordpress_app/widgets/imput_message.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String? uid;
  getUid() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    uid = sp.getString('uid');
  }

  @override
  void initState() {
    getUid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.userName.toString()).tr(),
      ),
      body:
          //  msg.hasData == false
          // ? ListView(
          //     children: [
          //       SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.10,
          //       ),
          //       EmptyPageWithImage(
          //           image: Config.noContentImage,
          //           title: 'no contents found'.tr())
          //     ],
          //   )
          //     :
          Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(uid)
                  // .doc("Fuggoi5F2jefEb9s6gjg")
                  .collection("Messages")
                  .where("receiverUid", isEqualTo: widget.user.uid!.trim())
                  .orderBy("sendDateTime")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                print(widget.user.uid!.trim());
                if (snapshot.hasError) {
                  return ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      EmptyPageWithImage(
                          image: Config.noContentImage,
                          title: 'no contents found'.tr())
                    ],
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingCard(
                      height: MediaQuery.of(context).size.height);
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return MessageBullet(
                        provider: data["provider"], message: data["message"]);
                  }).toList(),
                );
              },
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: InputWidget(user: widget.user)),
        ],
      ),
    );
  }
}
