import 'package:flutter/material.dart';
import 'package:ecosoftware/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecosoftware/styles/app_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  String? errorMessage = '';
  bool isLogin = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.5, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await AuthController().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await AuthController().createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  void _toggleForm() async {
    await _controller.forward();
    setState(() {
      isLogin = !isLogin;
    });
    _controller.reverse();
  }

  Widget _title() {
    return Text(
      isLogin ? 'Iniciar Sesión' : 'Registrarse',
      style: headingStyle.copyWith(fontSize: 28),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: inputDecoration(title),
      style: bodyTextStyle,
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Error: $errorMessage',
      style: errorTextStyle,
    );
  }

  Widget _submitButton() {
    return customButton(
      text: isLogin ? 'Iniciar Sesión' : 'Registrarse',
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: _toggleForm,
      child: Text(
        isLogin
            ? '¿No tienes una cuenta? Regístrate'
            : '¿Ya tienes una cuenta? Inicia Sesión',
        style: subHeadingStyle.copyWith(color: accentColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: _title(),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SlideTransition(
        position: _animation,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _entryField('Correo Electrónico', _emailController),
              const SizedBox(height: 20),
              _entryField('Contraseña', _passwordController),
              const SizedBox(height: 20),
              _errorMessage(),
              const SizedBox(height: 20),
              _submitButton(),
              const SizedBox(height: 10),
              _loginOrRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
