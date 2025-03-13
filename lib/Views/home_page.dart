import 'package:ecosoftware/styles/app_styles.dart';
import 'package:ecosoftware/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final User? user = AuthController().currentUser;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600), // Duración más lenta
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> signOut() async {
    await AuthController().signOut();
  }

  Widget _title() {
    return Text(
      'E C O S O F T W A R E',
      style: headingStyle.copyWith(fontSize: 28, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }

  Widget _userInfo() {
    return Text(
      'Bienvenido: ${user?.email ?? 'Invitado'}',
      style: subHeadingStyle.copyWith(color: Colors.black),
    );
  }

  Widget _signOutButton() {
    return IconButton(
      icon: Icon(Icons.exit_to_app, color: primaryColor),
      onPressed: signOut,
      color: Colors.white, // Color de fondo del botón
    );
  }

  Widget _dashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(label, style: bodyTextStyle.copyWith(color: Colors.white)),
          const SizedBox(width: 10),
          Container(
            width: 50, // Tamaño reducido
            height: 50, // Tamaño reducido
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: 25, // Tamaño reducido
                color: Colors.white, // Color del ícono
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    _controller.forward(from: 0.0);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.only(right: 20, bottom: 80),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _dashboardButton(
                      icon: Icons.calculate, // Ícono para Interés Simple
                      label: 'Interés Simple',
                      onPressed: () {
                        Navigator.pushNamed(context, '/interes_simple');
                      },
                    ),
                    const SizedBox(height: 10),
                    _dashboardButton(
                      icon: Icons.trending_up, // Ícono para Interés Compuesto
                      label: 'Interés Compuesto',
                      onPressed: () {
                        Navigator.pushNamed(context, '/interes_compuesto');
                      },
                    ),
                    const SizedBox(height: 10),
                    _dashboardButton(
                      icon: Icons.calendar_today, // Ícono para Anualidades
                      label: 'Anualidades',
                      onPressed: () {
                        Navigator.pushNamed(context, '/anualidades');
                      },
                    ),
                    const SizedBox(height: 10),
                    _dashboardButton(
                      icon: Icons.assignment, // Ícono para Amortización
                      label: 'Amortización',
                      onPressed: () {
                        Navigator.pushNamed(context, '/amortizacion');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Center(child: _title()),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _userInfo(),
            const SizedBox(height: 40),
            Expanded(
              child: Container(),
            ), // Espacio vacío en lugar de los botones
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft, // Alinea el botón a la izquierda
              child: _signOutButton(),
            ),
          ],
        ),
      ),
      floatingActionButton: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        child: FloatingActionButton(
          onPressed: () {
            _showMenu(context);
          },
          backgroundColor: primaryColor,
          child: Icon(
            Icons.add,
            size: 35, // Tamaño más grande
            color: Colors.white, // Color blanco
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
