import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Asegúrate que está importado

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print("[AuthController] Attempting Firebase sign in for $email...");
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("[AuthController] Firebase sign in successful for $email.");
    } on FirebaseAuthException catch (e) {
      print("[AuthController] FirebaseAuthException during sign in: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
       print("[AuthController] Generic error during sign in: $e");
       rethrow;
    }
  }

  // --- MODIFICADO: Aceptar nombres individuales y guardar en Firestore ---
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    // --- Parámetros de nombre individuales ---
    required String firstName,
    required String middleName, // Puede ser vacío
    required String firstLastName,
    required String secondLastName, // Puede ser vacío
    // --- Fin parámetros de nombre ---
    required String idType,
    required String idNumber,
  }) async {
    UserCredential? userCredential;
    try {
       print("[AuthController] Attempting Firebase user creation for $email...");
       userCredential = await _auth.createUserWithEmailAndPassword( email: email, password: password,);
       print("[AuthController] Firebase user created successfully: ${userCredential.user?.uid}");

       if (userCredential.user != null) {
         String uid = userCredential.user!.uid;
         DocumentReference userDocRef = _firestore.collection('users').doc(uid);
         print("[AuthController] Saving additional data to Firestore for UID: $uid");

         // Crear nombre completo combinando las partes (manejando opcionales)
         String fullName = '${firstName.trim()} ${middleName.trim()} ${firstLastName.trim()} ${secondLastName.trim()}'
                          .replaceAll(RegExp(r'\s+'), ' ') // Reemplazar múltiples espacios por uno solo
                          .trim(); // Quitar espacios al inicio/final

         // --- Guardar campos individuales y el completo ---
         await userDocRef.set({
           'uid': uid,
           'firstName': firstName.trim(), // Guardar primer nombre
           'middleName': middleName.trim(), // Guardar segundo nombre (puede ser vacío)
           'firstLastName': firstLastName.trim(), // Guardar primer apellido
           'secondLastName': secondLastName.trim(), // Guardar segundo apellido (puede ser vacío)
           'name': fullName, // Guardar nombre completo combinado (opcional, pero útil)
           'email': email,
           'idType': idType,
           'idNumber': idNumber,
           'createdAt': FieldValue.serverTimestamp(),
         });
         // --- Fin guardar campos ---

         print("[AuthController] Additional user data saved to Firestore.");
       }
    } on FirebaseAuthException catch (e) {
       print("[AuthController] FirebaseAuthException during user creation: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
        print("[AuthController] Generic error during user creation or Firestore write: $e");
        if (userCredential?.user != null) { /* ... (Intento de borrar usuario huérfano) ... */ print("[AuthController] Firestore write failed. Attempting delete..."); await userCredential!.user!.delete().catchError((deleteError) { print("[AuthController] Failed delete: $deleteError");}); }
        rethrow;
    }
  }
  // --- FIN MODIFICACIÓN ---

   Future<void> sendPasswordResetEmail({required String email}) async {
      try { print("[AuthController] Sending password reset email to $email..."); await _auth.sendPasswordResetEmail(email: email); print("[AuthController] Password reset email sent successfully."); } on FirebaseAuthException catch (e) { print("[AuthController] FirebaseAuthException during password reset: ${e.code} - ${e.message}"); rethrow; } catch (e) { print("[AuthController] Generic error during password reset: $e"); rethrow; }
   }

  Future<void> signOut() async {
     final String? lastEmail = await _secureStorage.read(key: 'last_email_biometric'); try { print("[AuthController] Attempting Firebase sign out..."); await _auth.signOut(); print("[AuthController] Firebase sign out successful."); if (lastEmail != null) { print("[AuthController] Clearing biometric data for $lastEmail on sign out..."); await _secureStorage.delete(key: 'biometric_enabled_for_$lastEmail'); await _secureStorage.delete(key: 'biometric_password_$lastEmail'); await _secureStorage.delete(key: 'last_email_biometric'); print("[AuthController] Biometric data cleared."); } } on FirebaseAuthException catch (e) { print("[AuthController] FirebaseAuthException during sign out: ${e.code} - ${e.message}"); rethrow; } catch (e) { print("[AuthController] Generic error during sign out (incl. storage clear): $e"); /* rethrow; opcional */ }
   }

} // Fin de la clase AuthController