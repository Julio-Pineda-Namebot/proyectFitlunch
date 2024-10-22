import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'navigation_Bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const users = {
  'admin@gmail.com': '12345',
};

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Email: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'Usuario no existe';
      }
      if (users[data.name] != data.password) {
        return 'Contraseña incorrecta';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Email: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Usuario no existe'; 
      }
      return null; 
    });
  }

  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'BIENVENIDO',
      theme: LoginTheme(
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 50.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.only(top: 15), 
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)), 
        ),
      ),
      onConfirmRecover: _signupConfirm,
      onConfirmSignup: _signupConfirm,
      additionalSignupFields: [
        const UserFormField(keyName: 'Nombres'),
        const UserFormField(keyName: 'Apellidos'),
        UserFormField(
          keyName: 'Telefono',
          displayName: 'Teléfono',
          icon: const Icon(FontAwesomeIcons.phone),
          userType: LoginUserType.phone,
          fieldValidator: (value) {
            final phoneRegExp = RegExp(
              r'^\+?\d{1,2}\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$',
            );
            if (value != null && !phoneRegExp.hasMatch(value)) {
              return "Es invalido el número ingresado";
            }
            return null;
          },
        ),
      ],
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Nombre: ${loginData.name}');
        debugPrint('Contraseña: ${loginData.password}');
        return _authUser(loginData);
      },
      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('Nombre: ${signupData.name}');
        debugPrint('Contraseña: ${signupData.password}');

        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
        });
        return _signupUser(signupData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const NavigationBarApp(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        userHint: 'Correo',
        passwordHint: 'Contraseña',
        confirmPasswordHint: 'Repetir Contraseña',
        loginButton: 'INGRESAR',
        signupButton: 'REGISTRARSE',
        forgotPasswordButton: 'Olvidaste tu contraseña?',
        recoverPasswordButton: 'RECUPERAR',
        recoverPasswordIntro: 'Restablece tu contraseña aquí',
        recoverCodePasswordDescription:'Ingrese su correo para recuperar contraseña!',
        goBackButton: 'VOLVER',
        confirmPasswordError: 'Error de contraseña!',
        recoverPasswordSuccess: 'Contraseña recuperada correctamente',
        confirmSignupIntro: 'Se envió un código de confirmación a su correo electrónico. Por favor ingrese el código para confirmar su cuenta',
        confirmationCodeHint: 'Código de confirmación',
        confirmationCodeValidationError: 'Código de confirmación esta vacío',
        resendCodeButton: 'Reenviaar código',
        resendCodeSuccess: 'Código de confirmación reenviado',
        confirmSignupButton: 'CONFIRMAR',
        confirmSignupSuccess: 'Cuenta confirmada',
        confirmRecoverIntro: 'El código de recuperación para establecer una nueva contraseña fue enviado a su correo electrónico.',
        recoveryCodeHint: 'Código de recuperación',
        recoveryCodeValidationError: 'Código de recuperación esta vacío',
        setPasswordButton: 'ESTABLECER CONTRASEÑA',
        confirmRecoverSuccess: 'Contraseña Recuperada',
        flushbarTitleError: 'Oh no!',
        flushbarTitleSuccess: 'Éxito!',
        signUpSuccess: 'Se ha enviado un enlace de  activación',
        additionalSignUpFormDescription: 'Por favor, completa este formulario para registrarte',
        additionalSignUpSubmitButton: 'ENVIAR',       
      ),
    );
  }
}
