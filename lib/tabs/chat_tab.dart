// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:wordpress_app/config/config.dart';
// import 'package:wordpress_app/config/wp_config.dart';
// import 'package:wordpress_app/models/article.dart';
// import 'package:http/http.dart' as http;
// import 'package:wordpress_app/cards/card3.dart';
// import 'package:wordpress_app/models/message.dart';
// import 'package:wordpress_app/utils/empty_image.dart';
// import 'package:wordpress_app/utils/loading_card.dart';
// import 'package:wordpress_app/utils/message_bullet.dart';
// import 'package:wordpress_app/widgets/imput_message.dart';
// import 'package:wordpress_app/widgets/loading_indicator_widget.dart';

// class ChatTab extends StatefulWidget {
//   ChatTab({Key? key}) : super(key: key);

//   @override
//   _ChatTabState createState() => _ChatTabState();
// }

// List<Map> messages = [
//   {
//     "provider": "me",
//     "message": "Hello John",
//   },
//   {
//     "provider": "external",
//     "message": "Hello Mael what's up?",
//   },
//   {
//     "provider": "me",
//     "message": "I'm good",
//   },
//   {
//     "provider": "external",
//     "message": "What's about your family?",
//   },
//   {
//     "provider": "me",
//     "message": "Nothing and you?",
//   },
//   {
//     "provider": "me",
//     "message": "And you?",
//   },
// ];

// class _ChatTabState extends State<ChatTab> with AutomaticKeepAliveClientMixin {
//   List<Message> _messages = [];
//   ScrollController? _controller;
//   // int _page = 1;
//   // bool? _loading;
//   bool? _hasData;
//   var scaffoldKey = GlobalKey<ScaffoldState>();
//   // int _postAmount = 10;

//   @override
//   void initState() {
//     // _controller =
//     //     ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
//     // _controller!.addListener(_scrollListener);
//     // _fetchArticles(1);
//     _hasData = true;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller!.dispose();
//   }

//   // Future _fetchArticles(int page) async {
//   //   try {
//   //     var response =
//   //         await http.get(Uri.parse("${WpConfig.websiteUrl}/wp-json/wp/v2/posts?"
//   //                 'page=$_page' +
//   //             '&tags=${WpConfig.videoTagId}' +
//   //             '&per_page=$_postAmount' +
//   //             "&_fields=id,date,title,content,custom,link,tags"));

//   //     if (this.mounted) {
//   //       if (response.statusCode == 200) {
//   //         List? decodedData = jsonDecode(response.body);
//   //         setState(() {
//   //           _articles
//   //               .addAll(decodedData!.map((m) => Article.fromJson(m)).toList());
//   //           _loading = false;
//   //           if (_articles.length == 0) {
//   //             _hasData = false;
//   //           }
//   //         });
//   //       }
//   //     }
//   //   } on SocketException {
//   //     throw 'No Internet connection';
//   //   }
//   // }

//   // _scrollListener() async {
//   //   var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
//   //       !_controller!.position.outOfRange;
//   //   if (isEnd && _articles.isNotEmpty) {
//   //     setState(() {
//   //       _page += 1;
//   //       _loading = true;
//   //     });
//   //     await _fetchArticles(_page).then((value) {
//   //       setState(() {
//   //         _loading = false;
//   //       });
//   //     });
//   //   }
//   // }

//   Future _onRefresh() async {
//     // setState(() {
//     //   _loading = null;
//     //   _articles.clear();
//     //   _hasData = true;
//     //   _page = 1;
//     // });
//     // await _fetchArticles(_page);
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         title: Text('Discussions').tr(),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 50.0),
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return MessageBullet(
//                     provider: messages[index]["provider"],
//                     message: messages[index]["message"]);
//               },
//             ),
//           ),
//           Align(alignment: Alignment.bottomCenter, child: InputWidget()),
//         ],
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
