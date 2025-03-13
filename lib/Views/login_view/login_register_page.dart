import 'package:flutter/material.dart';
import 'package:ecosoftware/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecosoftware/styles/app_styles.dart';
import 'package:local_auth/local_auth.dart'; // Importar local_auth
import 'package:shared_preferences/shared_preferences.dart'; // Importar shared_preferences

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
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  String _selectedIdType = 'CC';
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _fadeAnimation;
  final LocalAuthentication auth =
      LocalAuthentication(); // Instancia de LocalAuthentication

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

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    _checkBiometricAuth(); // Verificar autenticación biométrica al iniciar
  }

  Future<void> _checkBiometricAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isBiometricEnabled = prefs.getBool('isBiometricEnabled');
    if (isBiometricEnabled == true) {
      _authenticate();
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await AuthController().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isBiometricEnabled', true); // Guardar indicador
      Navigator.pushReplacementNamed(context, '/home'); // Navegar a la página de inicio
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Las contraseñas no coinciden';
      });
      return;
    }
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

  Future<void> resetPassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: _emailController.text,
    );
    setState(() {
      errorMessage = ''; // Limpiar mensaje de error
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Correo enviado',
            style: headingStyle.copyWith(color: primaryColor),
          ),
          content: Text(
            'Se ha enviado un correo para restablecer la contraseña',
            style: bodyTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Aceptar',
                style: subHeadingStyle.copyWith(color: primaryColor),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Por favor autentíquese para acceder',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated) {
        // Si la autenticación es exitosa, navegar a la página de inicio
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error de autenticación biométrica';
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

  Widget _entryField(
    String title,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: primaryColor),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: bodyTextStyle,
      obscureText: isPassword,
    );
  }

  Widget _idField() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: _selectedIdType,
            items: [
              DropdownMenuItem(value: 'CC', child: Text('CC')),
              DropdownMenuItem(value: 'PP', child: Text('PP')),
              DropdownMenuItem(value: 'CE', child: Text('CE')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedIdType = value!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Tipo de ID',
              labelStyle: TextStyle(color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: primaryColor),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: bodyTextStyle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(flex: 3, child: _entryField('Identificación', _idController)),
      ],
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Error: $errorMessage',
      style: errorTextStyle,
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
      ),
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(
        isLogin ? 'Iniciar Sesión' : 'Registrarse',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _biometricButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
      ),
      onPressed: _authenticate,
      child: Text(
        'Iniciar Sesión con Huella',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _forgotPasswordButton() {
    return TextButton(
      onPressed: resetPassword,
      child: Text(
        '¿Olvidaste tu contraseña?',
        style: subHeadingStyle.copyWith(color: primaryColor),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return Column(
      children: [
        TextButton(
          onPressed: _toggleForm,
          child: Text(
            isLogin
                ? '¿No tienes una cuenta? Regístrate'
                : '¿Ya tienes una cuenta? Inicia Sesión',
            style: subHeadingStyle.copyWith(color: primaryColor),
          ),
        ),
        if (isLogin) _forgotPasswordButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: null,
      ),
      body: Stack(
        children: [
          if (isLogin)
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HOLA!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32, // Tamaño de letra más grande
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'bienvenido a ecosoft',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 100,
                      height: 5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isLogin)
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: _toggleForm,
                          child: Text(
                            'Volver al inicio de sesión',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ),
                    if (!isLogin) const SizedBox(height: 20),
                    if (!isLogin) _entryField('Nombres', _nameController),
                    if (!isLogin) const SizedBox(height: 20),
                    if (!isLogin) _idField(),
                    if (!isLogin) const SizedBox(height: 20),
                    _entryField('Correo Electrónico', _emailController),
                    const SizedBox(height: 20),
                    _entryField(
                      'Contraseña',
                      _passwordController,
                      isPassword: true,
                    ),
                    if (!isLogin) const SizedBox(height: 20),
                    if (!isLogin)
                      _entryField(
                        'Confirmar Contraseña',
                        _confirmPasswordController,
                        isPassword: true,
                      ),
                    const SizedBox(height: 20),
                    _errorMessage(),
                    const SizedBox(height: 20),
                    _submitButton(),
                    const SizedBox(height: 10),
                    if (isLogin)
                      _biometricButton(), // Botón de autenticación biométrica
                    const SizedBox(height: 10),
                    if (isLogin) _loginOrRegisterButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
