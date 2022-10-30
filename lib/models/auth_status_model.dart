
import 'package:wordpress_app/models/user_model.dart';

class AuthStatus {

  final bool? isSuccessfull;
  final String? errorMessage;
  final UserModel? userModel;

  AuthStatus({
    this.isSuccessfull,
    this.errorMessage,
    this.userModel
  });
}