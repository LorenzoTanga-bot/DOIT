import 'package:doit/model/AuthCredential.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';

import 'package:doit/view/ThirdView.dart';
import 'package:doit/view/CreateModifyProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  String mail;

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
      await Provider.of<AuthCredentialProvider>(context, listen: false)
          .loginWithCredentials(new AuthCredential(login.name, login.password));
    } catch (e) {
      switch (e.toString()) {
        case 'Credential not found':
          return 'Email not found';
        case 'Invalid login':
          return 'Wrong password';
      }
    }
    return null;
  }

  Future<String> _newUser(LoginData login) async {
    try {
      await Provider.of<AuthCredentialProvider>(context, listen: false)
          .newMailPassword(new AuthCredential(login.name, login.password));
      mail = login.name;
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
          if (context
              .read<AuthCredentialProvider>()
              .getUser()
              .getRoles()
              .contains(UserRole.NOT_COMPLETED)) {
            Provider.of<ViewProvider>(context, listen: false)
                .setProfileDefault(CreateModifyProfile(
              isNewUser: true,
            ));
          } else {
            Provider.of<UserProvider>(context, listen: false).updateListUsers([
              Provider.of<AuthCredentialProvider>(context, listen: false)
                  .getUser()
                  .getMail()
            ]);
            Provider.of<ViewProvider>(context, listen: false)
                .setProfileDefault(ThirdView());
          }
        });
  }
}
