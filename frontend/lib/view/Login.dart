import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/LoadingLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  LoginMessages _buildLoginMessages() {
    return LoginMessages(
      usernameHint: 'Email',
      passwordHint: 'Password',
      confirmPasswordHint: 'Confirm Password',
      loginButton: 'LOGIN',
      signupButton: 'SIGN IN',
      forgotPasswordButton: 'Forgot password?',
      recoverPasswordButton: 'RECOVER',
      goBackButton: 'BACK',
      confirmPasswordError: 'The two passwords entered do not match!',
      recoverPasswordDescription: 'Password recovery procedure',
      recoverPasswordSuccess: 'Password recovered successfully',
    );
  }

  Future<String> _authUser(LoginData login) async {
    try {
      Provider.of<UserProvider>(context, listen: false)
          .authMailPassword(login.name, login.password);
    } catch (e) {
      switch (e.code) {
        case 'ERROR_USER_NOT_FOUND':
          return 'Email not found';
        case 'ERROR_WRONG_PASSWORD':
          return 'Wrong password';
        case 'ERROR_INVALID_EMAIL':
          return 'Invalid mail';
        case 'ERROR_USER_NOT_FOUND':
          return 'User not found';
        case 'ERROR_USER_DISABLED':
          return 'User disabled';
        case 'ERROR_TOO_MANY_REQUESTS':
          return 'Too many request';
        case 'ERROR_OPERATION_NOT_ALLOWED':
          return 'Operation not allowed';
      }
    }
    return null;
  }

  Future<String> _newUser(LoginData login) async {
    try {
      Provider.of<UserProvider>(context, listen: false)
          .newMailPassword(login.name, login.password);
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          return 'Invalid mail';
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return 'Mail already use';
      }
    }
    return null;
  }

  Future<String> _recoverPassword(String currentEmail) async {
    try {
      Provider.of<UserProvider>(context, listen: false)
          .recoverPassword(currentEmail);
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          return 'Invalid mail';
        case 'ERROR_USER_NOT_FOUND':
          return 'Mail doesn\'t exist';
      }
      return e.message;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        title: '',
        logo: 'assets/images/logo.png',
        messages: _buildLoginMessages(),
        onLogin: _authUser,
        onSignup: _newUser,
        onRecoverPassword: _recoverPassword,
        emailValidator: (value) {
          return value.isEmpty ? 'Mail entered invalid' : null;
        },
        passwordValidator: (value) {
          return value.isEmpty ? 'Invalid password entered' : null;
        },
        onSubmitAnimationCompleted: () {
          Provider.of<ViewProvider>(context, listen: false)
              .setProfileDefault(LoadingLogin());
        });
  }
}
