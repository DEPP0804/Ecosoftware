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
    return const Text('Firebase Auth');
  }

  Widget _userid() {
    return Text(user?.email ?? 'No user');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title()),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_userid(), _signOutButton()],
        ),
      ),
    );
  }
}
