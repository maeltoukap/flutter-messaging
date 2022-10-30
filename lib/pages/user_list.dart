// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wordpress_app/bloc/user/user_bloc.dart';
// import 'package:wordpress_app/configs/configs.dart';
// import 'package:wordpress_app/models/chat_message.dart';
// import 'package:wordpress_app/models/chat_user.dart';
// import 'package:wordpress_app/models/conversation_model.dart';
// import 'package:wordpress_app/models/user_model.dart';
// import 'package:wordpress_app/pages/welcome.dart';
// import 'package:wordpress_app/utils/empty_image.dart';
// import 'package:wordpress_app/utils/loading_card.dart';
// import 'package:wordpress_app/utils/navigation.dart';
// import 'package:wordpress_app/widgets/conversation.dart';

// class UserList extends StatefulWidget {
//   const UserList({Key? key}) : super(key: key);

//   @override
//   State<UserList> createState() => _UserListState();
// }

// // List<ChatUsers> chatUsers = [
// //   ChatUsers(
// //       name: "Jane Russel",
// //       messageText: "Awesome Setup",
// //       imageURL: "assets/images/icon.png",
// //       time: "Now"),
// //   ChatUsers(
// //       name: "Glady's Murphy",
// //       messageText: "That's Great",
// //       imageURL: "assets/images/icon.png",
// //       time: "Yesterday"),
// //   ChatUsers(
// //       name: "Jorge Henry",
// //       messageText: "Hey where are you?",
// //       imageURL: "assets/images/icon.png",
// //       time: "31 Mar"),
// //   ChatUsers(
// //       name: "Philip Fox",
// //       messageText: "Busy! Call me in 20 mins",
// //       imageURL: "assets/images/icon.png",
// //       time: "28 Mar"),
// //   ChatUsers(
// //       name: "Debra Hawkins",
// //       messageText: "Thankyou, It's awesome",
// //       imageURL: "assets/images/icon.png",
// //       time: "23 Mar"),
// //   ChatUsers(
// //       name: "Jacob Pena",
// //       messageText: "will update you in evening",
// //       imageURL: "assets/images/icon.png",
// //       time: "17 Mar"),
// //   ChatUsers(
// //       name: "Andrey Jones",
// //       messageText: "Can you please share the file?",
// //       imageURL: "assets/images/icon.png",
// //       time: "24 Feb"),
// //   ChatUsers(
// //       name: "John Wick",
// //       messageText: "How are you?",
// //       imageURL: "assets/images/icon.png",
// //       time: "18 Feb"),
// // ];

// List<ChatMessage> messages = [
//   ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
//   ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
//   ChatMessage(
//       messageContent: "Hey Kriss, I am doing fine dude. wbu?",
//       messageType: "sender"),
//   ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
//   ChatMessage(
//       messageContent: "Is there any thing wrong?", messageType: "sender"),
// ];

// String? email;
// // String? uid;

// class _UserListState extends State<UserList> {
//   getUid() async {
//     final SharedPreferences sp = await SharedPreferences.getInstance();
//     // uid = sp.getString('uid');
//     email = sp.getString('email');
//     // print(uid);
//   }

//   @override
//   void initState() {
//     getUid();
//     super.initState();
//     print(FirebaseAuth.instance.currentUser!.uid);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     const Text(
//                       "User List",
//                       style:
//                           TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                     ),
//                     IconButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         icon: Icon(Icons.close))
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search...",
//                   hintStyle: TextStyle(color: Colors.grey.shade600),
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: Colors.grey.shade600,
//                     size: 20,
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                   contentPadding: const EdgeInsets.all(8),
//                   border: InputBorder.none,
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       borderSide: BorderSide(color: Colors.grey.shade100)),
//                 ),
//               ),
//             ),
//             FutureBuilder<QuerySnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection("Users")
//                     .where("uid",
//                         isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
//                     // .doc("Fuggoi5F2jefEb9s6gjg")
//                     // .collection("Conversations")
//                     .get(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return const Text("Something went wrong");
//                   }
//                   if (!snapshot.hasData) {
//                     return LoadingCard(
//                         height: MediaQuery.of(context).size.height);
//                   }
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return LoadingCard(
//                         height: MediaQuery.of(context).size.height);
//                   }
//                   return ListView(
//                       shrinkWrap: true,
//                       padding: const EdgeInsets.only(top: 16),
//                       children:
//                           snapshot.data!.docs.map((DocumentSnapshot document) {
//                         Map<String, dynamic> data =
//                             document.data()! as Map<String, dynamic>;
//                         print(data["uid"]);
//                         return Conversation(
//                           conversationModel: ConversationModel(
//                               chatUsers: ChatUsers(
//                                   user: UserModel(
//                                       uid: data["uid"],
//                                       userEmail: data["email"],
//                                       userName: data["userName"]),
//                                   imageURL: "chatUsers[index]",
//                                   messageText: messages.last.messageContent,
//                                   time: "now"),
//                               messages: messages),
//                           isMessageRead: false,
//                         );
//                       }).toList());
//                 }),
//           ],
//         ),
//       ),
//     );
//   }

//   Future _handleLogout(context) async {
//     final UserBloc ub = BlocProvider.of<UserBloc>(context, listen: false);
//     await ub
//         .userSignout()
//         .then((value) => nextScreenCloseOthers(context, WelcomePage()));
//   }
// }
