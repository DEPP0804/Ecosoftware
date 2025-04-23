import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para actualizar Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Para obtener UID
import 'package:ecosoftware/styles/app_styles.dart'; // Para estilos y padding

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData; // Recibe los datos actuales

  const EditProfilePage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  bool _isLoading = false; // Estado de carga para el botón Guardar

  // Controladores para los campos editables
  late TextEditingController _nameController;
  late TextEditingController _idNumberController;
  late String _selectedIdType; // Variable de estado para el Dropdown

  // No editables (se muestran pero no se cambian aquí)
  late String _email;
  late String _uid;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores y variables con los datos recibidos
    _nameController = TextEditingController(text: widget.userData['name'] ?? '');
    _idNumberController = TextEditingController(text: widget.userData['idNumber'] ?? '');
    _selectedIdType = widget.userData['idType'] ?? 'CC'; // Usar 'CC' como default si no existe
    _email = widget.userData['email'] ?? FirebaseAuth.instance.currentUser?.email ?? 'N/A';
    _uid = widget.userData['uid'] ?? FirebaseAuth.instance.currentUser?.uid ?? 'N/A';
  }

  @override
  void dispose() {
    // Liberar controladores
    _nameController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  // --- Método para Guardar Cambios ---
  Future<void> _saveProfileChanges() async {
    // 1. Validar Formulario
    if (!(_formKey.currentState?.validate() ?? false)) {
      return; // No continuar si hay errores de validación
    }
    // 2. Verificar si hay usuario (aunque debería haberlo si llegó aquí)
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _showSnackBar('Error: No se pudo verificar el usuario.', isError: true);
      return;
    }

    // 3. Poner estado de carga
    setState(() => _isLoading = true);

    // 4. Preparar datos a actualizar (solo los que cambiaron o son editables)
    final Map<String, dynamic> updatedData = {
      'name': _nameController.text.trim(),
      'idType': _selectedIdType,
      'idNumber': _idNumberController.text.trim(),
      'lastUpdatedAt': FieldValue.serverTimestamp(), // Fecha de última actualización
    };

    // 5. Actualizar Firestore
    try {
      final DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await userDocRef.update(updatedData); // Usar update para modificar

      // 6. Mostrar éxito y volver
      _showSnackBar('Perfil actualizado correctamente.');
      if (mounted) {
         Navigator.pop(context); // Volver a la pantalla anterior (HomePage Perfil)
      }

    } catch (e) {
      // 7. Mostrar error
      print("Error al actualizar perfil: $e");
      _showErrorSnackBar('No se pudo actualizar el perfil. Intenta de nuevo.');
    } finally {
       // 8. Quitar estado de carga
       if (mounted) {
          setState(() => _isLoading = false);
       }
    }
  }

  // --- Helper para mostrar SnackBar ---
   void _showSnackBar(String message, {bool isError = false}) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(message), backgroundColor: isError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary, // Usar secundario para éxito
          behavior: SnackBarBehavior.floating, ), );
   }
   void _showErrorSnackBar(String message) { _showSnackBar(message, isError: true); }

  // --- Construcción de la Interfaz ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        // Estilos vienen del tema
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding * 1.5), // Más padding
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Estirar botón
            children: [
              // --- Campo Nombre ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                style: textTheme.bodyLarge,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: kDefaultPadding * 1.5),

              // --- Campo Email (Solo Lectura) ---
              TextFormField(
                initialValue: _email, // Usar initialValue para campos no editables
                readOnly: true, // Hacerlo no editable
                style: textTheme.bodyLarge?.copyWith(color: theme.disabledColor), // Estilo grisáceo
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email_outlined, color: theme.disabledColor),
                  border: InputBorder.none, // Quitar borde para que parezca texto normal
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  fillColor: Colors.transparent, // Sin fondo
                ),
              ),
              const SizedBox(height: kDefaultPadding * 1.5),

              // --- Campos ID (Tipo + Número) ---
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start, // Alinear bien con validación
                 children: [
                   Expanded(
                     flex: 2,
                     child: DropdownButtonFormField<String>(
                       value: _selectedIdType, // Vinculado al estado
                       items: const [
                         DropdownMenuItem(value: 'CC', child: Text('CC')),
                         DropdownMenuItem(value: 'PP', child: Text('PP')),
                         DropdownMenuItem(value: 'CE', child: Text('CE')),
                       ],
                       onChanged: (value) {
                         if (value != null) {
                           // Actualizar el estado cuando cambia la selección
                           setState(() => _selectedIdType = value);
                         }
                       },
                       decoration: const InputDecoration( labelText: 'Tipo ID',),
                       style: textTheme.bodyLarge,
                       validator: (value) { if (value == null) return 'Sel.'; return null;},
                       autovalidateMode: AutovalidateMode.onUserInteraction,
                     ),
                   ),
                   const SizedBox(width: kDefaultPadding / 1.5),
                   Expanded(
                     flex: 3,
                     child: TextFormField(
                       controller: _idNumberController,
                       decoration: const InputDecoration(
                         labelText: 'Núm. Identificación',
                         prefixIcon: Icon(Icons.badge_outlined),
                       ),
                       style: textTheme.bodyLarge,
                       keyboardType: TextInputType.number,
                       validator: (value) {
                         if (value == null || value.trim().isEmpty) return 'Requerido';
                         if (int.tryParse(value.trim()) == null) return 'Solo números';
                         return null;
                       },
                       autovalidateMode: AutovalidateMode.onUserInteraction,
                     ),
                   ),
                 ],
               ),
               const SizedBox(height: kDefaultPadding * 2.5), // Más espacio antes del botón

               // --- Botón Guardar ---
               ElevatedButton(
                 // Estilo viene del tema
                 onPressed: _isLoading ? null : _saveProfileChanges, // Llamar a la función de guardado
                 child: _isLoading
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                        : const Text('Guardar Cambios'),
               ),
            ],
          ),
        ),
      ),
    );
  }
}