import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para PlatformException
// Importar paquetes necesarios
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para obtener el usuario actual
// Importar estilos (asegúrate que kDefaultPadding esté definido aquí o globalmente)
import 'package:ecosoftware/styles/app_styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  bool _isLoading = true;
  bool _canUseBiometrics = false;
  bool _isBiometricEnabledForUser = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricSetting();
  }

  Future<void> _loadBiometricSetting() async {
    // ... (igual que antes: verifica usuario, capacidad y lee preferencia) ...
     if (_currentUser == null || _currentUser?.email == null) {
       if (mounted) setState(() => _isLoading = false); return;
     }
     bool deviceCanCheck = false;
     try { deviceCanCheck = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported(); }
     catch (e) { print("Error verificando capacidad biométrica: $e"); }
     String? storedPreference = await _secureStorage.read(key: 'biometric_enabled_for_${_currentUser!.email}');
     if (mounted) {
        setState(() {
          _canUseBiometrics = deviceCanCheck;
          _isBiometricEnabledForUser = storedPreference == 'true';
          _isLoading = false;
        });
     }
  }

  // --- MODIFICADO: Activa/Desactiva y Guarda/Borra Contraseña ---
  Future<void> _toggleBiometricSetting(bool enable) async {
    if (_currentUser == null || _currentUser?.email == null) {
      _showErrorSnackBar('Error: No se pudo identificar al usuario.'); return;
    }
    final String email = _currentUser!.email!;
    // Claves para Secure Storage
    final String storageKeyFlag = 'biometric_enabled_for_$email';
    final String storageKeyPassword = 'biometric_password_$email'; // Clave para contraseña
    final String storageKeyLastEmail = 'last_email_biometric';    // Clave para último email con biometría

    setState(() => _isLoading = true);

    try {
      if (enable) { // --- Habilitando ---
        // 0. Verificar capacidad del dispositivo (doble chequeo)
         if (!_canUseBiometrics) {
            throw PlatformException(code: 'NotAvailable', message: 'Biometría no disponible en este dispositivo.');
         }
         final availableBiometrics = await _localAuth.getAvailableBiometrics();
          if (availableBiometrics.isEmpty) {
            throw PlatformException(code: 'NotEnrolled', message: 'No hay huellas/rostros registrados en el dispositivo.');
          }

        // 1. Pedir contraseña actual al usuario
        final String? enteredPassword = await _promptForPassword(context);
        if (enteredPassword == null || enteredPassword.isEmpty) {
          throw Exception('Contraseña requerida para habilitar.');
        }

        // 2. (Opcional pero MUY recomendado) Verificar contraseña contra Firebase
        //    Esto previene guardar una contraseña incorrecta.
        try {
           // Intenta reautenticar o validar de alguna forma. Si usas reautenticación:
           AuthCredential credential = EmailAuthProvider.credential(email: email, password: enteredPassword);
           await _currentUser!.reauthenticateWithCredential(credential);
           print("Reautenticación exitosa antes de habilitar biometría.");
        } catch (e) {
            print("Error de reautenticación: $e");
           throw Exception('Contraseña incorrecta.'); // Lanzar excepción si falla
        }


        // 3. Pedir confirmación biométrica al usuario
        final bool authenticated = await _localAuth.authenticate(
          localizedReason: 'Confirma tu identidad para habilitar el inicio de sesión biométrico',
          options: const AuthenticationOptions(stickyAuth: true, biometricOnly: true),
        );

        // 4. Si la contraseña fue válida Y la biometría fue exitosa, guardar TODO
        if (authenticated) {
          await _secureStorage.write(key: storageKeyPassword, value: enteredPassword); // Guardar contraseña
          await _secureStorage.write(key: storageKeyFlag, value: 'true'); // Guardar flag
          await _secureStorage.write(key: storageKeyLastEmail, value: email); // Guardar email asociado
          if (mounted) {
            setState(() => _isBiometricEnabledForUser = true);
            _showSnackBar('Inicio de sesión biométrico habilitado.');
          }
        } else {
          throw Exception('Autenticación biométrica fallida o cancelada.');
        }

      } else { // --- Deshabilitando ---
        // Borrar contraseña, flag y último email asociado
        await _secureStorage.delete(key: storageKeyPassword);
        await _secureStorage.delete(key: storageKeyFlag);
        // Solo borrar last_email si es el mismo que el actual,
        // para no afectar otras cuentas si se implementara multicuenta.
        final lastEmail = await _secureStorage.read(key: storageKeyLastEmail);
        if (lastEmail == email) {
             await _secureStorage.delete(key: storageKeyLastEmail);
        }

        if (mounted) {
          setState(() => _isBiometricEnabledForUser = false);
          _showSnackBar('Inicio de sesión biométrico deshabilitado.');
        }
      }
    } on PlatformException catch (e) {
        print("Error PlatformException al cambiar biometría: $e");
        _showErrorSnackBar('Error: ${e.message ?? "No se pudo completar."}');
         // Revertir estado visual del switch si falló la habilitación
         if (enable && mounted) setState(() => _isBiometricEnabledForUser = false);
    } catch (e) {
        print("Error inesperado al cambiar biometría: $e");
        _showErrorSnackBar('Error: ${e.toString().replaceFirst("Exception: ", "")}');
         // Revertir estado visual del switch si falló la habilitación
        if (enable && mounted) setState(() => _isBiometricEnabledForUser = false);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- Helper para pedir contraseña ---
  Future<String?> _promptForPassword(BuildContext context) async {
    final TextEditingController pwdController = TextEditingController();
    final theme = Theme.of(context); // Obtener tema para el diálogo
    return await showDialog<String>(
      context: context,
      barrierDismissible: false, // No permitir cerrar tocando fuera
      builder: (dialogContext) => AlertDialog(
        title: Text("Confirmar Identidad", style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Ajustar tamaño
          children: [
             Text("Ingresa tu contraseña actual para continuar.", style: theme.textTheme.bodyMedium),
             const SizedBox(height: kDefaultPadding),
             TextField( // Usar TextField simple aquí está bien
               controller: pwdController,
               obscureText: true,
               decoration: const InputDecoration( // Usará tema por defecto
                  labelText: "Contraseña Actual",
                  prefixIcon: Icon(Icons.lock_outline),
               ),
               autofocus: true, // Abrir teclado automáticamente
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(null), // Devolver null al cancelar
            child: const Text("Cancelar")
          ),
          ElevatedButton(
            onPressed: () {
              // Devolver la contraseña ingresada (puede estar vacía)
              Navigator.of(dialogContext).pop(pwdController.text);
            },
            child: const Text("Confirmar")
          ),
        ],
      ),
    );
  }

  // --- Helper para mostrar SnackBar ---
  void _showSnackBar(String message, {bool isError = false}) { /* ... (igual que antes) ... */
     if (!mounted) return;
     ScaffoldMessenger.of(context).showSnackBar( SnackBar(
         content: Text(message), backgroundColor: isError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary, // Usar secundario para éxito? O verde?
         behavior: SnackBarBehavior.floating, ), );
   }
  void _showErrorSnackBar(String message) { _showSnackBar(message, isError: true); }


  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguridad y Biometría'), // Título más específico
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                SwitchListTile(
                  title: Text('Inicio de sesión biométrico', style: textTheme.titleMedium),
                  subtitle: Text(
                    _canUseBiometrics
                        ? 'Usa tu huella o rostro para iniciar sesión más rápido.'
                        : 'Biometría no disponible o no configurada en este dispositivo.',
                    style: textTheme.bodySmall,
                  ),
                  value: _isBiometricEnabledForUser,
                  onChanged: (_canUseBiometrics && _currentUser != null && !_isLoading)
                      ? _toggleBiometricSetting // Llamar directamente a la función
                      : null, // Deshabilitado si no se puede usar o está cargando
                  secondary: Icon(
                     Icons.fingerprint,
                     color: _canUseBiometrics && _currentUser != null
                              ? theme.colorScheme.primary
                              : theme.disabledColor,
                  ),
                  activeColor: theme.colorScheme.primary,
                ),
                // ... (Otras opciones de configuración) ...
              ],
            ),
    );
  }
}