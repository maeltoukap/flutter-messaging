import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wordpress_app/bloc/user/user_bloc.dart';
import 'package:wordpress_app/models/auth_status_model.dart';
import 'package:wordpress_app/models/icon_data.dart';
import 'package:wordpress_app/pages/done.dart';
import 'package:wordpress_app/pages/login.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/auth_service.dart';
import 'package:wordpress_app/utils/navigation.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({Key? key, this.popUpScreen}) : super(key: key);

  final bool? popUpScreen;

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var userNameCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  final _btnController = new RoundedLoadingButtonController();

  bool offsecureText = true;
  Icon lockIcon = LockIcon().lock;

  void _onlockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        lockIcon = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = LockIcon().lock;
      });
    }
  }

  Future _handleCreateUser() async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    if (userNameCtrl.text.isEmpty) {
      _btnController.reset();
      openSnacbar(scaffoldKey, 'Username is required');
    } else if (emailCtrl.text.isEmpty) {
      _btnController.reset();
      openSnacbar(scaffoldKey, 'Email is required');
    } else if (passwordCtrl.text.isEmpty) {
      _btnController.reset();
      openSnacbar(scaffoldKey, 'Password is required');
    } else {
      AppService().checkInternet().then((hasInternet) async {
        if (!hasInternet!) {
          _btnController.reset();
          openSnacbar(scaffoldKey, 'no internet'.tr());
        } else {
          print(userNameCtrl.text);
          print(emailCtrl.text);
          print(passwordCtrl.text);
          await AuthService()
              .signUpWithFirebase(
                  userNameCtrl.text, emailCtrl.text, passwordCtrl.text)
              .then((AuthStatus? authStatus) async {
            if (authStatus == null || authStatus.isSuccessfull == false) {
              _btnController.reset();
              openSnacbar(scaffoldKey, authStatus!.errorMessage);
              print("Auth statut: " + authStatus.isSuccessfull.toString());
            } else {
              var idToken = await FirebaseMessaging.instance.getToken();
              await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(authStatus.userModel!.uid)
                  .set({
                "email": emailCtrl.text,
                "userName": userNameCtrl.text,
                "uid":  authStatus.userModel!.uid,
                "fcmToken": idToken
              });
              print("Auth statut: " + authStatus.isSuccessfull.toString());
              await ub
                  .guestUserSignout()
                  .then((value) => ub.saveUserData(authStatus.userModel!))
                  .then((value) => ub.setSignIn())
                  .then((value) {
                ub.saveUserData(authStatus.userModel!);
                _btnController.success();
                afterSignUp();
              });
            }
          });
        }
      });
    }
  }

  void afterSignUp() async {
    if (widget.popUpScreen == null || widget.popUpScreen == false) {
      nextScreen(context, const DonePage());
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'create account',
              style: TextStyle(
                  letterSpacing: -0.7,
                  wordSpacing: 1,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ).tr(),
            const SizedBox(
              height: 15,
            ),
            Text(
              'follow the simple steps',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary),
            ).tr(),
            const SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Username',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 1,
                      letterSpacing: -0.7),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter username',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.person,
                          size: 20,
                        )),
                    controller: userNameCtrl,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const Text(
                  'Email Address',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 1,
                      letterSpacing: -0.7),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter email address',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.person,
                          size: 20,
                        )),
                    controller: emailCtrl,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const Text(
                  'Password',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 1,
                      letterSpacing: -0.7),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                            icon: lockIcon, onPressed: () => _onlockPressed()),
                        prefixIcon: const Icon(
                          Icons.lock,
                          size: 20,
                        )),
                    controller: passwordCtrl,
                    obscureText: offsecureText,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                RoundedLoadingButton(
                  animateOnTap: true,
                  child: Wrap(
                    children: [
                      Text(
                        'create',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ).tr()
                    ],
                  ),
                  controller: _btnController,
                  onPressed: () => _handleCreateUser(),
                  width: MediaQuery.of(context).size.width * 1.0,
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "already have an account?",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary),
                      ).tr(),
                      TextButton(
                          child: Text(
                            'login',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary),
                          ).tr(),
                          onPressed: () => nextScreenReplace(
                              context,
                              LoginPage(
                                popUpScreen: widget.popUpScreen,
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
