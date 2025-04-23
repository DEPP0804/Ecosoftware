// lib/Views/login_view/login_register_page.dart

import 'package:flutter/material.dart';
import 'package:ecosoftware/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecosoftware/styles/app_styles.dart'; // Para AppTheme, kDefault*

// Firestore necesario para guardar datos en registro
import 'package:cloud_firestore/cloud_firestore.dart';

// --- Constantes (Mover a app_styles.dart) ---
const double kDefaultPadding = 16.0;
const double kDefaultBorderRadius = 12.0;
// --- Fin Constantes ---

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Mantener mixin si se usa la animación del header
class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {

  String? _errorMessage;
  bool _isLoading = false;
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _firstLastNameController = TextEditingController();
  final TextEditingController _secondLastNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  String _selectedIdType = 'CC';

  // Animación Header
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController( duration: const Duration(milliseconds: 800), vsync: this,);
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    if (_isLogin) { _animationController.forward(); }
    // Ya no se llama a _checkBiometricStatus
  }

  @override
  void dispose() {
    // Dispose todos los controllers
    _emailController.dispose(); _passwordController.dispose(); _confirmPasswordController.dispose();
    _firstNameController.dispose(); _middleNameController.dispose(); _firstLastNameController.dispose(); _secondLastNameController.dispose();
    _idController.dispose(); _animationController.dispose();
    super.dispose();
  }

  // --- Métodos de Autenticación ---
  String _mapFirebaseAuthExceptionMessage(String? code) {
    switch (code) {
      case 'user-not-found': return 'Correo electrónico no encontrado.'; // Email/Pass login
      case 'wrong-password': return 'Contraseña incorrecta.';
      case 'invalid-email': return 'Formato de correo inválido.';
      case 'email-already-in-use': return 'El correo ya está registrado.';
      case 'weak-password': return 'La contraseña es demasiado débil (mínimo 6 caracteres).';
      case 'too-many-requests': return 'Demasiados intentos. Intenta más tarde.';
      default: return 'Error de autenticación (${code ?? 'desconocido'}).';
    }
  }

  Future<void> _performAuthAction(Future<void> Function() action) async {
      // Simplificado sin isPasswordSignIn
      if (_isLoading) return; FocusScope.of(context).unfocus(); if (!(_formKey.currentState?.validate() ?? false)) return; if (!_isLogin && _passwordController.text != _confirmPasswordController.text) { setState(() => _errorMessage = 'Las contraseñas no coinciden.'); return; }
      setState(() { _isLoading = true; _errorMessage = null; }); try { print("[PerformAuth] Awaiting action()..."); await action(); print("[PerformAuth] action() completed successfully."); } on FirebaseAuthException catch (e) { print("[PerformAuth] FirebaseAuthException caught: ${e.code}"); if(mounted) setState(() { _errorMessage = _mapFirebaseAuthExceptionMessage(e.code); }); } catch (e) { print("[PerformAuth] Generic Exception caught: ${e.toString()}"); if(mounted) setState(() { _errorMessage = 'Ocurrió un error: ${e.toString().replaceFirst("Exception: ", "")}'; }); } finally { print("[PerformAuth] Finally block reached. Setting isLoading = false."); if (mounted) { setState(() => _isLoading = false); } }
   }

  // --- _signIn Restaurado a Email/Password ---
  Future<void> _signIn() async {
     if (!(_formKey.currentState?.validate() ?? false)) { return; } // Validar email y pass
     await _performAuthAction(
        () => AuthController().signInWithEmailAndPassword(
             email: _emailController.text.trim(),
             password: _passwordController.text.trim(),
           )
     );
   }

  // --- _signUp (pasa todos los datos de registro) ---
  Future<void> _signUp() async {
      if (!_formKey.currentState!.validate()){ return; }
       await _performAuthAction( () => AuthController().createUserWithEmailAndPassword(
              email: _emailController.text.trim(), password: _passwordController.text.trim(),
              firstName: _firstNameController.text.trim(), middleName: _middleNameController.text.trim(),
              firstLastName: _firstLastNameController.text.trim(), secondLastName: _secondLastNameController.text.trim(),
              idType: _selectedIdType, idNumber: _idController.text.trim(),
            ));
   }

  // --- _resetPassword (pide email) ---
  Future<void> _resetPassword() async {
       if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) { setState(() => _errorMessage = 'Ingresa tu correo asociado para restablecer.'); return; } if (_isLoading) return; setState(() { _isLoading = true; _errorMessage = null; }); FocusScope.of(context).unfocus(); try { await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim()); if (mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar( content: const Text('Correo de restablecimiento enviado.'), backgroundColor: Theme.of(context).colorScheme.secondary, behavior: SnackBarBehavior.floating,)); } } on FirebaseAuthException catch (e) { if (mounted) { setState(() => _errorMessage = _mapFirebaseAuthExceptionMessage(e.code)); } } catch (e) { if (mounted) { setState(() => _errorMessage = 'Error al enviar el correo.'); } } finally { if (mounted) { setState(() => _isLoading = false); } }
   }

  // --- _toggleForm (sin cambios) ---
  void _toggleForm() {
      setState(() { _isLogin = !_isLogin; _errorMessage = null; _formKey.currentState?.reset(); if (_isLogin) { _animationController.forward(); } else { _animationController.reverse(); } });
    }

  // --- MÉTODO BIOMÉTRICO ELIMINADO ---


  // --- Widgets de UI (IMPLEMENTACIONES COMPLETAS) ---

  Widget _buildHeaderText(ThemeData theme) {
       return Positioned( top: 20, left: kDefaultPadding, child: FadeTransition( opacity: _fadeAnimation, child: Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [ Text( 'HOLA!', style: theme.textTheme.headlineMedium?.copyWith( color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),), const SizedBox(height: 4), Text( 'Bienvenido a ecosoft', style: theme.textTheme.titleLarge?.copyWith( color: theme.colorScheme.onPrimary.withOpacity(0.9)), ), Container( margin: const EdgeInsets.only(top: kDefaultPadding), width: 100, height: 4, decoration: BoxDecoration( color: theme.colorScheme.onPrimary, borderRadius: BorderRadius.circular(2),)) ],),),);
   }

  Widget _entryField( String title, TextEditingController controller, { bool isPassword = false, TextInputType keyboardType = TextInputType.text, IconData? prefixIcon, bool isConfirmPassword = false, String? Function(String?)? validator, bool isOptional = false, TextCapitalization textCapitalization = TextCapitalization.none, } ) {
        final theme = Theme.of(context); final bool obscureTextCurrent = isPassword ? (isConfirmPassword ? _obscureConfirmPassword : _obscurePassword) : false; return TextFormField( controller: controller, obscureText: obscureTextCurrent, keyboardType: keyboardType, textCapitalization: textCapitalization, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface), decoration: InputDecoration( labelText: title + (isOptional ? " (Opcional)" : ""), prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: theme.colorScheme.primary, size: 20) : const Padding(padding: EdgeInsets.only(left: kDefaultPadding / 2)), suffixIcon: isPassword ? IconButton( icon: Icon( obscureTextCurrent ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: theme.colorScheme.primary, size: 20,), onPressed: () { setState(() { if (isConfirmPassword) _obscureConfirmPassword = !_obscureConfirmPassword; else _obscurePassword = !_obscurePassword; }); },) : null, ), validator: validator ?? (value) { if (isOptional && (value == null || value.isEmpty)) { return null; } if (value == null || value.isEmpty) { return 'Requerido'; } if (title.contains('Correo') && !value.contains('@')) { return 'Correo inválido'; } return null; }, autovalidateMode: AutovalidateMode.onUserInteraction, textInputAction: TextInputAction.next, );
    }

  Widget _idField(ThemeData theme) {
         return Row( crossAxisAlignment: CrossAxisAlignment.start, children: [ Expanded( flex: 2, child: DropdownButtonFormField<String>( value: _selectedIdType, items: const [ DropdownMenuItem(value: 'CC', child: Text('CC')), DropdownMenuItem(value: 'PP', child: Text('PP')), DropdownMenuItem(value: 'CE', child: Text('CE')), ], onChanged: (value) { if (value != null) { setState(() => _selectedIdType = value); FocusScope.of(context).nextFocus(); } }, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface), decoration: const InputDecoration( labelText: 'Tipo', ), validator: (value) { if (value == null) return 'Sel.'; return null; }, autovalidateMode: AutovalidateMode.onUserInteraction, ),), const SizedBox(width: kDefaultPadding / 1.5), Expanded( flex: 3, child: _entryField( 'Identificación', _idController, keyboardType: TextInputType.number, prefixIcon: Icons.badge_outlined, validator: (value){ if (value == null || value.isEmpty) return 'Requerido'; if(int.tryParse(value) == null) return 'Solo números'; return null; } )), ], );
     }

  Widget _errorMessageWidget(ThemeData theme) {
        if (_errorMessage == null || _errorMessage!.isEmpty) return const SizedBox.shrink(); return Padding( padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2), child: Text( _errorMessage!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error), textAlign: TextAlign.center,), );
      }

  Widget _submitButton(ThemeData theme) {
        return ElevatedButton( style: theme.elevatedButtonTheme.style, onPressed: _isLoading ? null : (_isLogin ? _signIn : _signUp), child: _isLoading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : Text(_isLogin ? 'Iniciar Sesión' : 'Crear Cuenta'), );
      }

  Widget _forgotPasswordButton(ThemeData theme) {
         if (!_isLogin) return const SizedBox.shrink(); return TextButton( onPressed: _isLoading ? null : _resetPassword, style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: kDefaultPadding/2)), child: const Text('¿Olvidaste tu contraseña?'), );
       }

  Widget _loginOrRegisterButton(ThemeData theme) {
         return TextButton( onPressed: _isLoading ? null : _toggleForm, style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: kDefaultPadding/2)), child: Text(_isLogin ? '¿No tienes cuenta? Regístrate' : '¿Ya tienes cuenta? Inicia Sesión'), );
       }


  // --- Build Method (Restaurado a Login con Email/Pass, sin Biometría) ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.primary,
      body: GestureDetector(
         onTap: () => FocusScope.of(context).unfocus(),
         child: Stack(
           children: [
             // Header
             if (_isLogin) _buildHeaderText(theme),

             // Formulario
             Align(
               alignment: Alignment.bottomCenter,
               child: Container(
                 height: MediaQuery.of(context).size.height * (_isLogin ? 0.65 : 0.90), // Reducida altura para Login
                 padding: const EdgeInsets.all(kDefaultPadding * 1.5),
                 decoration: BoxDecoration( color: theme.colorScheme.surface, borderRadius: const BorderRadius.only( topLeft: Radius.circular(kDefaultBorderRadius * 2), topRight: Radius.circular(kDefaultBorderRadius * 2),), boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.1), blurRadius: 15, spreadRadius: 5, offset: const Offset(0, -5),),],),
                 child: SingleChildScrollView(
                   child: Form(
                      key: _formKey,
                      child: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           // --- Campos de Registro ---
                           if (!_isLogin) ...[
                             _entryField( 'Primer Nombre', _firstNameController, prefixIcon: Icons.person_outline, keyboardType: TextInputType.name, textCapitalization: TextCapitalization.words, validator:(v) => v == null || v.trim().isEmpty ? 'Primer nombre requerido' : null,),
                             const SizedBox(height: kDefaultPadding * 1.2),
                             _entryField( 'Segundo Nombre', _middleNameController, prefixIcon: Icons.person_outline, keyboardType: TextInputType.name, textCapitalization: TextCapitalization.words, isOptional: true),
                             const SizedBox(height: kDefaultPadding * 1.2),
                              _entryField( 'Primer Apellido', _firstLastNameController, prefixIcon: Icons.person_outline, keyboardType: TextInputType.name, textCapitalization: TextCapitalization.words, validator:(v) => v == null || v.trim().isEmpty ? 'Primer apellido requerido' : null,),
                             const SizedBox(height: kDefaultPadding * 1.2),
                             _entryField( 'Segundo Apellido', _secondLastNameController, prefixIcon: Icons.person_outline, keyboardType: TextInputType.name, textCapitalization: TextCapitalization.words, isOptional: true),
                             const SizedBox(height: kDefaultPadding * 1.2),
                             _entryField( 'Correo Electrónico', _emailController, keyboardType: TextInputType.emailAddress, prefixIcon: Icons.email_outlined, validator: (v){ if (v == null || v.isEmpty || !v.contains('@')) { return 'Correo inválido'; } return null;} ),
                             const SizedBox(height: kDefaultPadding * 1.2),
                             _idField(theme), // ID para Registro
                             const SizedBox(height: kDefaultPadding * 1.2),
                             _entryField( 'Contraseña', _passwordController, isPassword: true, prefixIcon: Icons.lock_outline, validator: (v) { if (v == null || v.isEmpty) return 'Requerido'; if (v.length < 6) return 'Mínimo 6 caracteres'; return null; }),
                             const SizedBox(height: kDefaultPadding * 1.2),
                             _entryField( 'Confirmar Contraseña', _confirmPasswordController, isPassword: true, prefixIcon: Icons.lock_outline, isConfirmPassword: true, validator: (v) { if (v == null || v.isEmpty) return 'Confirma'; if (v != _passwordController.text) return 'No coinciden'; return null; } ),
                             const SizedBox(height: kDefaultPadding * 1.5),
                           ],

                           // --- Campos de Login (Email y Contraseña) ---
                           if (_isLogin) ...[
                              // **** CAMPO EMAIL PARA LOGIN ****
                              _entryField(
                                'Correo Electrónico',
                                _emailController, // Usa el controller de email
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icons.email_outlined,
                                validator: (v){ if (v == null || v.isEmpty || !v.contains('@')) { return 'Correo inválido'; } return null;}
                              ),
                              const SizedBox(height: kDefaultPadding * 1.2),
                              // Contraseña para Login (sin botón biométrico ahora)
                              _entryField(
                                'Contraseña',
                                _passwordController,
                                isPassword: true,
                                prefixIcon: Icons.lock_outline,
                                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                              ),
                              Align( alignment: Alignment.centerRight, child: _forgotPasswordButton(theme)),
                              const SizedBox(height: kDefaultPadding * 1.5), // Más espacio antes del error
                           ],

                           // --- Común: Error, Submit, Toggle ---
                           _errorMessageWidget(theme),
                           const SizedBox(height: kDefaultPadding / 2),
                           _submitButton(theme),
                           const SizedBox(height: kDefaultPadding),
                           _loginOrRegisterButton(theme),
                           SizedBox(height: MediaQuery.of(context).viewInsets.bottom + kDefaultPadding),
                         ],
                       ),
                    ),
                 ),
               ),
             ),
           ],
         ),
      ),
    );
  }

} // ***** FIN DE LA CLASE _LoginPageState *****