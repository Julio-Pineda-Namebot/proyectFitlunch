import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fitlunch/page/navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitlunch/api/api_userlogin.dart';

class LoginScreen extends StatelessWidget {
  final apiService = ApiService();
  LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    try {
      final datau = await apiService.login(data.name, data.password);
      if (datau != null) {
        return null; 
      } else {
        return 'Usuario no encontrado';
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    final userData = {
      'X_NOMBRE': data.additionalSignupData?['Nombres'] ?? '',
      'X_APELLIDO': data.additionalSignupData?['Apellidos'] ?? '',
      'X_EMAIL': data.name,
      'X_CONTRASENA': data.password,
      'X_TELEFONO': data.additionalSignupData?['Telefono'] ?? '',
    };

    try {
      final response = await apiService.register(userData);
      if (response != null) {
        return null; 
      } else {
        return 'Error al registrar usuario';
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> _signupConfirm(String verificationCode, LoginData data) async {
    if (verificationCode.isEmpty) {
      return 'Código de verificación está vacío';
    }
    try {
      final response = await apiService.verifyCode(data.name, verificationCode);
      if (response == null) {
        return null; 
      } else {
        return 'Código de verificación incorrecto';
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> _resendVerificationCode(String email) async {
    try {
      final response = await apiService.resendCode(email);
      if (response == null) {
        return null; 
      } else {
        return response; 
      }
    } catch (error) {
      return error.toString(); 
    }
  }

  Future<String?> _recoverPassword(String email) async {
    return await apiService.sendRecoveryEmail(email);
  }

  Future<String?> _resetPassword(String email, String code, String newPassword) async {
    return await apiService.resetPassword(email, code, newPassword);
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
      onRecoverPassword: _recoverPassword, 
      onConfirmRecover: (code, recoverData) async {
        final email = recoverData.name; 
        final newPassword = recoverData.password; 

        return await _resetPassword(email, code, newPassword);
      },
      onConfirmSignup: _signupConfirm,
      onResendCode: (SignupData data) async {
        final email = data.name; 
        if (email == null || email.isEmpty) {
          return 'El correo electrónico es obligatorio';
        } 
        return await _resendVerificationCode(email);
      },
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
              r'^\d{9}$',
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
        debugPrint('Correo: ${loginData.name}');
        debugPrint('Contraseña: ${loginData.password}');
        return _authUser(loginData);
      },
      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('Correo: ${signupData.name}');
        debugPrint('Contraseña: ${signupData.password}');

        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
        });
        return _signupUser(signupData);
      },
      userValidator: (value) {
        final emailRegExp = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        );
        if (value == null || value.isEmpty) {
          return 'Correo electrónico es obligatorio';
        } else if (!emailRegExp.hasMatch(value)) {
          return 'Formato de correo inválido';
        }
        return null;
      },
      passwordValidator: (value) {
        final passwordRegExp = RegExp(
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,16}$'
        );
        if (value == null || value.isEmpty) {
          return 'La contraseña es obligatoria';
        } else if (!passwordRegExp.hasMatch(value)) {
          return 'Debe tener de 8 a 16 caracteres, Incluyendo\nletras, números y carácter especial.';
        }
        return null; 
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const NavigationBarApp(),
        ));
      },
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
        recoverPasswordSuccess: 'Código de confirmación enviado',
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
