import 'package:ecosoftware/styles/app_styles.dart';
import 'package:ecosoftware/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = AuthController().currentUser;

  Future<void> signOut() async {
    await AuthController().signOut();
  }

  Widget _title() {
    return Text(
      'E C O S O F T W A R E',
      style: headingStyle.copyWith(fontSize: 28, color: Colors.white),
    );
  }

  Widget _userInfo() {
    return Text(
      'Bienvenido: ${user?.email ?? 'Invitado'}',
      style: subHeadingStyle.copyWith(color: Colors.black),
    );
  }

  Widget _signOutButton() {
    return customButton(text: 'Cerrar Sesión', onPressed: signOut);
  }

  Widget _dashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFFF1F8E9),
              borderRadius: BorderRadius.circular(20),
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
                size: 50,
                color: primaryColor, // Color del ícono
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: bodyTextStyle.copyWith(color: Colors.black)),
      ],
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _userInfo(),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _dashboardButton(
                    icon: Icons.calculate, // Ícono para Interés Simple
                    label: 'Interés Simple',
                    onPressed: () {
                      Navigator.pushNamed(context, '/interes_simple');
                    },
                  ),
                  _dashboardButton(
                    icon: Icons.trending_up, // Ícono para Interés Compuesto
                    label: 'Interés Compuesto',
                    onPressed: () {
                      Navigator.pushNamed(context, '/interes_compuesto');
                    },
                  ),
                  _dashboardButton(
                    icon: Icons.calendar_today, // Ícono para Anualidades
                    label: 'Anualidades',
                    onPressed: () {
                      Navigator.pushNamed(context, '/anualidades');
                    },
                  ),
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
            const SizedBox(height: 20),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
