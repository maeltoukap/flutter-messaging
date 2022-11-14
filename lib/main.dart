import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
// import 'package:hive/hive.dart';
import 'package:wordpress_app/app.dart';
import 'package:wordpress_app/hive/hive_message.dart';
import 'package:wordpress_app/models/constants_model.dart';
import 'package:wordpress_app/tabs/user_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  ///Hive For local database
  var path = Directory.current.path;
  await Hive.initFlutter();
  Hive.registerAdapter<LocalMessageModel>(LocalMessageModelAdapter());
  await Hive.openBox<LocalMessageModel>('Messages');

  // var path = Directory.current.path;
  // Hive
  //   ..init(path)
  //   ..registerAdapter(LocalMessageServiceAdapter())
  //   ..openBox("Messages");

  // Directory directory = await getApplicationDocumentsDirectory();
  // Hive.init(directory.path);
  // await Hive.openBox(Constants.bookmarkTag);
  // await Hive.openBox(Constants.resentSearchTag);
  // await Hive.openBox(Constants.notificationTag);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  // print('User granted permission: ${settings.authorizationStatus}');

  runApp(EasyLocalization(
    supportedLocales: [Locale('en'), Locale('ar'), Locale('es')],
    path: 'assets/translations',
    fallbackLocale: Locale('en'),

    //Defaut language
    startLocale: Locale('en'),
    useOnlyLangCode: true,
    // child: UserList(),
    child: MyApp(),
  ));
}
