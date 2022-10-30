import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wordpress_app/models/auth_status_model.dart';
import 'package:wordpress_app/models/user_model.dart';

class AuthService {
  /// Firebase authentication
  /// -----------------------------------SIGN UP ----------------------------------------
  int i = 0;
  Future<AuthStatus?> signUpWithFirebase(
      String userName, String email, String password) async {
    AuthStatus? status;
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        // print(value.user!.uid);
        // FirebaseFirestore.instance
        //     .collection("Users")
        //     .doc(value.user!.uid)
        //     .set({
        //   "email": email,
        //   "userName": userName,
        //   "uid": value.user!.uid,
        //   "fcmToken": value.user!.getIdToken()
        // });
        print("conneced");
        status = AuthStatus(
          isSuccessfull: true,
          errorMessage: 'null',
          userModel: UserModel(
              id: i++,
              uid: value.user!.uid,
              userName: userName.trim(),
              userEmail: email.trim()),
        );
      });
      //     .then((value) {
      // });

      // final String uid = FirebaseAuth.instance.currentUser!.uid;

      // print(status.isSuccessfull);
      return status;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return AuthStatus(
          errorMessage: 'Weak password',
          isSuccessfull: false,
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return AuthStatus(
          errorMessage: 'Email is already in use!',
          isSuccessfull: false,
        );
      }
    } catch (e) {
      print(e);
      return status == null
          ? AuthStatus(
              errorMessage: 'Username or Email is already in use!',
              isSuccessfull: false,
            )
          : status;
    }
  }

  //--------------------------------SIGN IN-----------------------------------

  Future<UserModel?> loginWithUsernamePassword(
      String email, String password) async {
    AuthStatus? status;
    UserModel? userModel;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //     .then((value) {
      // });
      // final String uid = FirebaseAuth.instance.currentUser!.uid;

      status = AuthStatus(
        isSuccessfull: true,
        errorMessage: 'null',
        userModel: UserModel(
            id: i++,
            uid: credential.user!.uid,
            userEmail: email.trim(),
            userName: "maeltoukap"),
      );
      return status.userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        // return AuthStatus(
        //   errorMessage: 'Weak password',
        //   isSuccessfull: false,
        // );
        return UserModel(
            id: i++, uid: "credential.user!.uid", userEmail: email.trim());
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        // return AuthStatus(
        //   errorMessage: 'Email is already in use!',
        //   isSuccessfull: false,
        // );
        return UserModel(
            id: i++, uid: "credential.user!.uid", userEmail: email.trim());
      }
    } catch (e) {
      print(e);
      // return status == null
      //     ? AuthStatus(
      //         errorMessage: 'Username or Email is already in use!',
      //         isSuccessfull: false,
      //       )
      //     : status;
      return UserModel(
          id: i++, uid: "credential.user!.uid", userEmail: email.trim());
    }
  }
}
