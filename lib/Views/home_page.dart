import 'package:ecosoftware/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Importar estilos
import 'package:ecosoftware/styles/app_styles.dart'; // Asegúrate que kDefaultPadding esté aquí

// --- Importar Firestore ---
import 'package:cloud_firestore/cloud_firestore.dart';
// --- Fin Importar Firestore ---

// --- Importar Páginas ---
import 'package:ecosoftware/Views/Pages/Perfil/settings_page.dart';
import 'package:ecosoftware/Views/Pages/Perfil/edit_profile_page.dart';
// --- Importar Página de Pagos --- (Asegúrate que la ruta sea correcta)
import 'package:ecosoftware/Views/Pages/payments_page.dart';

// --- Importar Páginas de Calculadoras (Si NO usas rutas nombradas, descomenta) ---
// import 'package:ecosoftware/Views/Pages/interes_simple.dart';
// import 'package:ecosoftware/Views/Pages/interes_compuesto.dart';
// import 'package:ecosoftware/Views/Pages/anualidades.dart';
// import 'package:ecosoftware/Views/Pages/amortizacion.dart';
// import 'package:ecosoftware/Views/Pages/sistemas_capitalizacion.dart';
// import 'package:ecosoftware/Views/Pages/loan_simulation_page.dart'; // <-- Necesitarás crear esta página
// import 'package:ecosoftware/Views/Pages/gradientes.dart';
// import 'package:ecosoftware/Views/Pages/inflacion.dart'; // Si usas InflacionPage
// import 'package:ecosoftware/Views/Pages/tasa_interes_retorno.dart'; // Si usas TasaInteresRetornoPage

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = AuthController().currentUser;
  int _selectedIndex = 0;

  // Método para obtener los datos del perfil de Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUserProfile() async {
    if (user == null) {
      throw Exception("Usuario no autenticado.");
    }
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid);
      final snapshot = await docRef.get();
      return snapshot;
    } catch (e) {
      print("Error fetching user profile: $e");
      rethrow;
    }
  }

  // Método para cerrar sesión con confirmación
  Future<void> _signOut(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(
            'Confirmar Cierre de Sesión',
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            '¿Estás seguro de que deseas salir?',
            style: theme.textTheme.bodyMedium,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      try {
        await AuthController().signOut();
        // No necesitas pop aquí si AuthController maneja el cambio de estado y la UI reacciona.
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  // --- Widgets de UI (Helpers) ---
  Widget _buildAppBarTitle(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle =
        theme.appBarTheme.titleTextStyle ??
        theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
        );
    return Text(
      'E C O S O F T W A R E',
      style: textStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor =
        theme.appBarTheme.actionsIconTheme?.color ??
        theme.colorScheme.onPrimary;
    return IconButton(
      icon: Icon(Icons.exit_to_app, color: iconColor),
      tooltip: 'Cerrar Sesión',
      onPressed: () => _signOut(context),
    );
  }

  // --- Contenido para cada Pestaña ---

  Widget _buildHomePageBody(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // Mostrar nombre de Firestore si existe, si no, parte del email
            'Bienvenido!', // Se muestra el nombre en el perfil, aquí un saludo genérico está bien
            style: textTheme.headlineMedium?.copyWith( // Un poco más grande
              fontWeight: FontWeight.w400, // Normal
            ),
          ),
          const SizedBox(height: kDefaultPadding / 2),
          // Muestra el nombre del usuario si está disponible, si no el email
           FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _fetchUserProfile(),
              builder: (context, snapshot) {
                String displayName = user?.email?.split('@')[0] ?? 'Invitado'; // Fallback
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data!.exists &&
                    snapshot.data!.data()?['name'] != null &&
                    snapshot.data!.data()!['name'].isNotEmpty) {
                  displayName = snapshot.data!.data()!['name'];
                }
                // No mostrar nada durante la carga o si hay error aquí,
                // solo el fallback o el nombre cargado
                return Text(
                   displayName,
                   style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                   ),
                 );
              }
            ),

          const SizedBox(height: kDefaultPadding * 1.5),
          Card(
            elevation: 2.0, // Sombra sutil
            shape: RoundedRectangleBorder( // Bordes redondeados
              borderRadius: BorderRadius.circular(kDefaultPadding / 2)
            ),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CUENTA DE AHORROS', // O el tipo de cuenta principal
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.secondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding / 2),
                  Text(
                    '**** **** **** 1234', // TODO: Obtener número real (ofuscado)
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Text('Saldo Disponible', style: textTheme.bodySmall),
                  // TODO: Obtener saldo real
                  Text(
                    '\$ 1,234,567.89', // Ejemplo
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding * 1.5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.visibility_outlined,
                        size: 18,
                        color: colorScheme.secondary,
                      ),
                      label: Text(
                        'Ver Detalles',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                      onPressed: () {
                        // TODO: Navegar a la pantalla de detalles de la cuenta
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Navegar a detalles de cuenta... (TODO)'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: kDefaultPadding * 2),
          Center(
            child: Text(
              'Usa la barra inferior para navegar',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderPage(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.construction_outlined,
            size: 80,
            color: theme.disabledColor,
          ),
          const SizedBox(height: kDefaultPadding),
          Text(
            '$title (En Construcción)',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorsPageBody(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(kDefaultPadding),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: kDefaultPadding),
          child: Text(
            "Calculadoras Financieras",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        _buildCalculatorListTile(
          context: context,
          theme: theme,
          icon: Icons.percent_outlined,
          title: 'Interés Simple',
          routeName: '/interes_simple', // Asegúrate que esta ruta esté definida
        ),
        _buildCalculatorListTile(
          context: context,
          theme: theme,
          icon: Icons.trending_up_outlined,
          title: 'Interés Compuesto',
           routeName: '/interes_compuesto', // Asegúrate que esta ruta esté definida
        ),
        _buildCalculatorListTile(
          context: context,
          theme: theme,
          icon: Icons.calendar_today_outlined,
          title: 'Anualidades',
           routeName: '/anualidades', // Asegúrate que esta ruta esté definida
        ),
        _buildCalculatorListTile(
          context: context,
          theme: theme,
          icon: Icons.receipt_long_outlined,
          title: 'Amortización',
          routeName: '/amortizacion', // Asegúrate que esta ruta esté definida
        ),
        _buildCalculatorListTile(
          context: context,
          theme: theme,
          icon: Icons.calculate_outlined,
          title: 'Sistemas de Capitalización',
          routeName: '/sistemas_capitalizacion', // Asegúrate que esta ruta esté definida
        ),
        _buildCalculatorListTile(
          context: context,
          theme: theme,
          icon: Icons.request_quote_outlined, // Icono sugerido para simulación/cotización
          title: 'Simulación de Créditos',
          routeName: '/simulacion_creditos', // Define la ruta para esta nueva sección
        ),
        _buildCalculatorListTile(
          context: context,
          theme: theme,
          icon: Icons.ssid_chart_outlined,
          title: 'Tasa de Interés y Retorno',
          routeName: '/tasa_interes_retorno',
        ),
        _buildCalculatorListTile(
          context: context,
          theme: theme,
          icon: Icons.arrow_upward_outlined,
          title: 'Inflación',
          routeName: '/inflacion',
        ),
        _buildCalculatorListTile(
          context: context,
          theme: theme,
          icon: Icons.gradient_outlined,
          title: 'Gradientes',
          routeName: '/gradientes',
        ),
      ],
    );
  }

  Widget _buildCalculatorListTile({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String routeName,
  }) {
    return Card( // Envolver en Card para mejor apariencia
      margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.secondary),
        title: Text(title, style: theme.textTheme.titleMedium),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
           // Asegúrate que las rutas nombradas estén configuradas en tu MaterialApp
           Navigator.pushNamed(context, routeName);
        },
      ),
    );
  }

  // --- Contenido Pestaña "Perfil" ---
  Widget _buildProfilePageBody(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _fetchUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Text(
                'Error al cargar el perfil: ${snapshot.error}',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if (!snapshot.hasData ||
            snapshot.data == null ||
            !snapshot.data!.exists) {
          // Perfil no existe en Firestore, mostrar datos básicos y opción de editar
          final String name = 'Completa tu perfil';
          final String email = user?.email ?? 'N/A';
          final String idType = '--';
          final String idNumber = 'N/A';

          return _buildProfileContent(context, theme, textTheme, colorScheme, name, email, idType, idNumber, null); // Pasar null para userData

        }

        // Datos cargados de Firestore
        final userData = snapshot.data!.data();
        final String name = userData?['name'] ?? 'Actualiza tu nombre';
        final String email = userData?['email'] ?? user?.email ?? 'N/A';
        final String idType = userData?['idType'] ?? '--';
        final String idNumber = userData?['idNumber'] ?? 'Actualiza tu ID';

        return _buildProfileContent(context, theme, textTheme, colorScheme, name, email, idType, idNumber, userData);
      },
    );
  }

  // Helper widget para construir el contenido del perfil (evita repetición)
  Widget _buildProfileContent(
      BuildContext context,
      ThemeData theme,
      TextTheme textTheme,
      ColorScheme colorScheme,
      String name,
      String email,
      String idType,
      String idNumber,
      Map<String, dynamic>? userData // Hacer userData opcional
   ) {
     return ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Center(
            child: CircleAvatar(
              radius: 45,
              backgroundColor:
                  colorScheme.primaryContainer ??
                  colorScheme.primary.withOpacity(0.1),
              child: Text(
                // Mostrar inicial o '?' si no hay nombre o es el placeholder
                 (name.isNotEmpty && name != 'Actualiza tu nombre' && name != 'Completa tu perfil')
                    ? name[0].toUpperCase()
                    : '?',
                style: textTheme.displaySmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          Center(child: Text(name, style: textTheme.headlineSmall)),
          const SizedBox(height: kDefaultPadding / 2),
          Center(child: Text(email, style: textTheme.bodyMedium)),
          const SizedBox(height: kDefaultPadding / 2),
           if (idNumber != 'N/A' && idNumber != 'Actualiza tu ID') // Solo mostrar si hay ID
             Center(
               child: Text('$idType $idNumber', style: textTheme.bodyMedium),
             ),
          const SizedBox(height: kDefaultPadding * 1.5),

          // --- Botón Editar Perfil ---
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(userData != null ? 'Editar Perfil' : 'Completar Perfil'), // Cambiar texto si no hay datos
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Pasa los datos existentes (incluso si son nulos/vacíos) a EditProfilePage
                      // EditProfilePage deberá manejar el caso donde userData es null o incompleto.
                      builder: (context) => EditProfilePage(userData: userData ?? {}), // Pasa un mapa vacío si es null
                    ),
                  ).then((_) {
                    // Refrescar datos al volver
                    if (mounted) {
                      setState(() {});
                    }
                  });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size.zero, // Ajustar tamaño
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 1.5,
                  vertical: kDefaultPadding / 2,
                ),
                textStyle: textTheme.labelMedium,
              ),
            ),
          ),
          Divider(
            height: kDefaultPadding * 2.5,
            thickness: 1,
            color: theme.dividerTheme.color,
          ),

          // --- Sección Configuración ---
          Text(
            'Configuración',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: kDefaultPadding / 2),
          ListTile(
            leading: Icon(
              Icons.security_outlined,
              color: colorScheme.primary,
            ),
            title: Text(
              'Seguridad y Biometría',
              style: textTheme.titleMedium,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          Divider( // Separador sutil
            indent: 50, // Indentación para que empiece después del icono
            endIndent: 10,
            color: theme.dividerTheme.color?.withOpacity(0.5),
          ),
          ListTile(
            leading: Icon(
              Icons.notifications_outlined,
              color: colorScheme.primary,
            ),
            title: Text('Notificaciones', style: textTheme.titleMedium),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navegar a la pantalla de configuración de notificaciones
               ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configuración Notificaciones (TODO)')),
                );
            },
          ),
           ListTile(
            leading: Icon(Icons.help_outline, color: colorScheme.primary),
            title: Text('Ayuda y Soporte', style: textTheme.titleMedium),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navegar a la pantalla de ayuda/FAQ/contacto
               ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ayuda y Soporte (TODO)')),
                );
            },
          ),
        ],
      );
  }


  // --- Método Build Principal ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // --- Definición de las páginas para el IndexedStack ---
    final List<Widget> pageOptions = <Widget>[
      _buildHomePageBody(context),
      _buildPlaceholderPage(context, 'Transferencias'), // Placeholder para Transferencias
      const PaymentsPage(),                          // Página de Pagos real
      _buildCalculatorsPageBody(context),            // Página de Calculadoras real
      _buildProfilePageBody(context),               // Página de Perfil real
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: _buildAppBarTitle(context),
        centerTitle: true,
        automaticallyImplyLeading: false, // No mostrar botón de regreso en AppBar
        actions: <Widget>[
          _buildSignOutButton(context),
          const SizedBox(width: kDefaultPadding / 2), // Pequeño espacio
        ],
        // elevation: 0, // Opcional: quitar sombra del AppBar
        // backgroundColor: theme.primaryColor, // Opcional: definir color explícito
      ),
      // Usar IndexedStack para mantener el estado de cada página al cambiar de pestaña
      body: IndexedStack(
          index: _selectedIndex,
          children: pageOptions
      ),
      bottomNavigationBar: BottomNavigationBar(
        // --- Configuración de la Barra de Navegación Inferior ---
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Icono cuando está activa
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_outlined),
             activeIcon: Icon(Icons.swap_horiz),
            label: 'Transferir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            activeIcon: Icon(Icons.payment),
            label: 'Pagos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
             activeIcon: Icon(Icons.calculate),
            label: 'Calculos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
             activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex, // Índice de la pestaña actual
        onTap: (int index) {         // Callback cuando se toca una pestaña
          setState(() {
            _selectedIndex = index;   // Actualizar el índice seleccionado
          });
        },
        // --- Estilos de la Barra de Navegación ---
        type: BottomNavigationBarType.fixed, // Para que todos los labels se vean
        selectedItemColor: theme.colorScheme.primary, // Color del ítem activo
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6), // Color de ítems inactivos
        // selectedFontSize: 12, // Tamaño de fuente del label activo (opcional)
        // unselectedFontSize: 12, // Tamaño de fuente del label inactivo (opcional)
        // showUnselectedLabels: true, // Asegurarse que los labels inactivos se vean
        // backgroundColor: theme.colorScheme.surface, // Color de fondo (opcional)
      ),
    );
  }
} // Fin _HomePageState