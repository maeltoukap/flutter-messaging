import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_app/bloc/user/user_bloc.dart';
import 'package:wordpress_app/configs/configs.dart';
import 'package:wordpress_app/pages/create_account.dart';
import 'package:wordpress_app/pages/done.dart';
import 'package:wordpress_app/pages/login.dart';
import 'package:wordpress_app/utils/navigation.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void _onSkipPressed() async {
    final UserBloc ub = BlocProvider.of<UserBloc>(context, listen: false);
    //     final SharedPreferences sp = await SharedPreferences.getInstance();
    //  final  uid = sp.getString('uid');
    // nextScreen(context, DonePage(uid: uid!));
    await ub.loginAsGuestUser().then((_) {
      nextScreen(context, const DonePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            elevation: 0,
            actions: [
              TextButton(
                style: const ButtonStyle(),
                child: const Text(
                  'skip',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ).tr(),
                onPressed: () => _onSkipPressed(),
              ),
              IconButton(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                iconSize: 18,
                icon: const Icon(Feather.globe),
                onPressed: () {
                  // nextScreenPopup(context, LanguagePopup());
                },
              ),
            ],
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Image(
                        image: const AssetImage(Config.splash),
                        height: 130,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'welcome to',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w300,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ).tr(),
                              const SizedBox(
                                width: 5,
                              ),
                              const Image(
                                image: AssetImage(Config.logo),
                                height: 40,
                                width: 160,
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 35, right: 35, top: 15),
                            child: Text(
                              'welcome-intro',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ).tr(),
                          )
                        ],
                      ),
                    ],
                  )),
              const Spacer(),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width * 0.80,
                      height: 45,
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith((states) =>
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Theme.of(context).primaryColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "login to continue",
                              style: TextStyle(
                                  letterSpacing: -0.7,
                                  wordSpacing: 1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ).tr(),
                            const SizedBox(
                              width: 15,
                            ),
                            const Icon(
                              Feather.arrow_right,
                              color: Colors.white,
                            )
                          ],
                        ),
                        onPressed: () => nextScreen(context, LoginPage()),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "don't have an account?",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary),
                        ).tr(),
                        TextButton(
                          child: Text(
                            'create',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary),
                          ).tr(),
                          onPressed: () =>
                              nextScreen(context, CreateAccountPage()),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
