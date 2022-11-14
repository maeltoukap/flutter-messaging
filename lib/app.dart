import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordpress_app/bloc/notifications/notifications_bloc.dart';
import 'package:wordpress_app/bloc/theme/theme_bloc.dart';
import 'package:wordpress_app/bloc/user/user_bloc.dart';
import 'package:wordpress_app/models/theme.dart';
import 'package:wordpress_app/pages/splash.dart';
import 'package:wordpress_app/tabs/user_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (BuildContext context) => UserBloc(),
          ),
          BlocProvider<NotificationsBloc>(
            create: (BuildContext context) => NotificationsBloc(),
          ),
          BlocProvider<ThemeBloc>(
            create: (BuildContext context) => ThemeBloc(),
          ),
        ],
        // child: SplashPage(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            // navigatorObservers: [firebaseObserver],
            locale: context.locale,
            theme: ThemeModel().lightTheme,
            darkTheme: ThemeModel().darkTheme,
            // themeMode:
            //     mode.darkTheme == true ? ThemeMode.dark : ThemeMode.light,
            home: SplashPage())
        // MaterialApp(
        //   title: 'Flutter wordpress_app',
        //   theme: ThemeData(
        //     primarySwatch: Colors.blue,
        //   ),
        //   home: UserList(),
        // )
        );
  }
}
