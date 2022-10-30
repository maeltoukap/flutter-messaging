import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordpress_app/bloc/user/user_bloc.dart';
import 'package:wordpress_app/configs/configs.dart';
import 'package:wordpress_app/pages/home.dart';
import 'package:wordpress_app/pages/welcome.dart';
import 'package:wordpress_app/utils/navigation.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  Future _afterSplash() async {
    final UserBloc ub = context.read<UserBloc>();
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      ub.isSignedIn == true || ub.guestUser == true
          ? _gotoHomePage()
          : _gotoWelcomePage();
    });
  }

  void _gotoHomePage() {
    nextScreenReplace(context, HomePage());
  }

  void _gotoWelcomePage() {
    nextScreenReplace(context, WelcomePage());
  }

  @override
  void initState() {
    _afterSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          height: 120,
          width: 120,
          image: AssetImage(Config.splash),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}