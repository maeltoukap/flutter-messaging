import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_app/bloc/user/user_bloc.dart';
import 'package:wordpress_app/configs/configs.dart';
import 'package:wordpress_app/models/chat_message.dart';
import 'package:wordpress_app/models/chat_user.dart';
import 'package:wordpress_app/models/conversation_model.dart';
import 'package:wordpress_app/models/discussion_model.dart';
import 'package:wordpress_app/models/user_model.dart';
import 'package:wordpress_app/pages/welcome.dart';
import 'package:wordpress_app/pages/user_list.dart';
import 'package:wordpress_app/utils/conversation_loading.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/utils/navigation.dart';
import 'package:wordpress_app/widgets/conversation-copy.dart';

class Conversations extends StatefulWidget {
  const Conversations({Key? key}) : super(key: key);

  @override
  State<Conversations> createState() => _ConversationsState();
}

// List<ChatUsers> chatUsers = [
//   ChatUsers(
//       name: "Jane Russel",
//       messageText: "Awesome Setup",
//       imageURL: "assets/images/icon.png",
//       time: "Now"),
//   ChatUsers(
//       name: "Glady's Murphy",
//       messageText: "That's Great",
//       imageURL: "assets/images/icon.png",
//       time: "Yesterday"),
//   ChatUsers(
//       name: "Jorge Henry",
//       messageText: "Hey where are you?",
//       imageURL: "assets/images/icon.png",
//       time: "31 Mar"),
//   ChatUsers(
//       name: "Philip Fox",
//       messageText: "Busy! Call me in 20 mins",
//       imageURL: "assets/images/icon.png",
//       time: "28 Mar"),
//   ChatUsers(
//       name: "Debra Hawkins",
//       messageText: "Thankyou, It's awesome",
//       imageURL: "assets/images/icon.png",
//       time: "23 Mar"),
//   ChatUsers(
//       name: "Jacob Pena",
//       messageText: "will update you in evening",
//       imageURL: "assets/images/icon.png",
//       time: "17 Mar"),
//   ChatUsers(
//       name: "Andrey Jones",
//       messageText: "Can you please share the file?",
//       imageURL: "assets/images/icon.png",
//       time: "24 Feb"),
//   ChatUsers(
//       name: "John Wick",
//       messageText: "How are you?",
//       imageURL: "assets/images/icon.png",
//       time: "18 Feb"),
// ];

List<ChatMessage> messages = [
  ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
  ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
  ChatMessage(
      messageContent: "Hey Kriss, I am doing fine dude. wbu?",
      messageType: "sender"),
  ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
  ChatMessage(
      messageContent: "Is there any thing wrong?", messageType: "sender"),
];

String? email;
// String? uid;

class _ConversationsState extends State<Conversations> {
  getUid() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    // uid = sp.getString('uid');
    email = sp.getString('email');
    // print(uid);
  }

  @override
  void initState() {
    getUid();
    super.initState();
    print(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        nextScreen(context, UserList());
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.pink[50],
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.add,
                              color: Colors.pink,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Text(
                              "Add New",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            // IconButton(
                            //   icon: const Icon(FontAwesome.user),
                            //   onPressed: () {
                            //     _handleLogout(context);
                            //   },
                            // )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("Conversations")
                    // .where("uid",
                    //     isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    // .doc("Fuggoi5F2jefEb9s6gjg")
                    // .collection("Conversations")
                    .get(),
                builder: (context, snapshot) {
                  // print(snapshot.data!.size);
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
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
                    return ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ConversationLoadingCard();
                        });
                  }
                  return ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        print(data["uid"]);
                        return Conversation(
                          discussions: DiscussionModel(
                              uid: data["uid"],
                              creationDateTime: data["creationDateTime"],
                              lastestMessage: data["lastestMessage"],
                              latestProvider: data["latestProvider"],
                              isLastMessageHasBeenRead:
                                  data["isLastMessageHasBeenRead"],
                              user1: data["user1"],
                              user2: data["user2"],
                              senderEmail: data["senderEmail"],
                              receiverEmail: data["receiverEmail"],
                              senderUsername: data["senderUsername"],
                              receiverUsername: data["receiverUsername"]),
                          pageProvider: "Conversations",
                          // ConversationModel(
                          //     chatUsers: ChatUsers(
                          //         // uid: data["uid"],
                          //         // name: data['userName'],
                          //         user: UserModel(
                          //             uid: data["uid"],
                          //             userEmail: data["email"],
                          //             userName: data["userName"]),
                          //         imageURL: "chatUsers[index]",
                          //         messageText: messages.last.messageContent,
                          //         time: "now"),
                          //     messages: messages),
                          isMessageRead: false,
                        );
                      }).toList());

                  //     ListView.builder(
                  //   itemCount: chatUsers.length,
                  //   shrinkWrap: true,
                  //   padding: EdgeInsets.only(top: 16),
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemBuilder: (context, index) {
                  //     return Conversation(
                  //       name: chatUsers[index].name,
                  //       messageText: chatUsers[index].messageText,
                  //       imageUrl: chatUsers[index].imageURL,
                  //       time: chatUsers[index].time,
                  //       isMessageRead:
                  //           (index == 0 || index == 3) ? true : false,
                  //     );
                  //   },
                  // );
                }),
          ],
        ),
      ),
    );
  }

  Future _handleLogout(context) async {
    final UserBloc ub = BlocProvider.of<UserBloc>(context, listen: false);
    await ub
        .userSignout()
        .then((value) => nextScreenCloseOthers(context, WelcomePage()));
  }
}
