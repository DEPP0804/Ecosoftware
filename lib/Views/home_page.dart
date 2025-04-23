import 'package:ecosoftware/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Importar estilos
import 'package:ecosoftware/styles/app_styles.dart'; // Asegúrate que kDefaultPadding esté aquí

// --- Importar Firestore ---
import 'package:cloud_firestore/cloud_firestore.dart';
// --- Fin Importar Firestore ---

// --- Importar Páginas ---
import 'package:ecosoftware/Views/Pages/settings_page.dart';
// --- ¡NUEVA IMPORTACIÓN PARA EDITAR PERFIL! ---
import 'package:ecosoftware/Views/Pages/edit_profile_page.dart';
// --- FIN IMPORTACIÓN ---
// Puedes comentar las importaciones de calculadoras si usas rutas nombradas
// import 'package:ecosoftware/Views/Pages/interes_simple.dart';
// import 'package:ecosoftware/Views/Pages/interes_compuesto.dart';
// import 'package:ecosoftware/Views/Pages/anualidades.dart';
// import 'package:ecosoftware/Views/Pages/amortizacion.dart';


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
    if (user == null) { throw Exception("Usuario no autenticado."); }
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      final snapshot = await docRef.get();
      // No lanzar error si no existe, FutureBuilder lo manejará
      // if (!snapshot.exists) { throw Exception("Perfil no encontrado."); }
      return snapshot;
    } catch (e) { print("Error fetching user profile: $e"); rethrow; }
  }

  // Método para cerrar sesión con confirmación
  Future<void> _signOut(BuildContext context) async { /* ... (igual que antes) ... */
     final bool? confirm = await showDialog<bool>( context: context, barrierDismissible: false, builder: (BuildContext dialogContext) {
          final theme = Theme.of(dialogContext); return AlertDialog( title: Text('Confirmar Cierre de Sesión', style: theme.textTheme.titleLarge), content: Text('¿Estás seguro de que deseas salir?', style: theme.textTheme.bodyMedium),
            actions: <Widget>[ TextButton( onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancelar'),), TextButton( style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error), onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text('Cerrar Sesión'),),],); }, );
     if (confirm == true) { try { await AuthController().signOut(); } catch (e) { if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar( SnackBar( content: Text('Error al cerrar sesión: ${e.toString()}'), backgroundColor: Theme.of(context).colorScheme.error,),); } }
   }

  // --- Widgets de UI (Helpers) ---
  Widget _buildAppBarTitle(BuildContext context) { /* ... (igual que antes) ... */
     final theme = Theme.of(context); final textStyle = theme.appBarTheme.titleTextStyle ?? theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary); return Text( 'E C O S O F T W A R E', style: textStyle, textAlign: TextAlign.center, );
   }
  Widget _buildSignOutButton(BuildContext context) { /* ... (igual que antes) ... */
     final theme = Theme.of(context); final iconColor = theme.appBarTheme.actionsIconTheme?.color ?? theme.colorScheme.onPrimary; return IconButton( icon: Icon(Icons.exit_to_app, color: iconColor), tooltip: 'Cerrar Sesión', onPressed: () => _signOut(context), );
   }

  // --- Contenido para cada Pestaña ---

  Widget _buildHomePageBody(BuildContext context) { /* ... (igual que antes, con la Card) ... */
     final theme = Theme.of(context); final textTheme = theme.textTheme; final colorScheme = theme.colorScheme; return SingleChildScrollView( padding: const EdgeInsets.all(kDefaultPadding), child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ Text( 'Bienvenido, ${user?.email?.split('@')[0] ?? 'Invitado'}!', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal), ), const SizedBox(height: kDefaultPadding * 1.5), Card( child: Padding( padding: const EdgeInsets.all(kDefaultPadding), child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ Text( 'CUENTA DE AHORROS', style: textTheme.labelMedium?.copyWith(color: colorScheme.secondary, letterSpacing: 0.8), ), const SizedBox(height: kDefaultPadding / 2), Text( '**** **** **** 1234', style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)), ), const SizedBox(height: kDefaultPadding), Text( 'Saldo Disponible', style: textTheme.bodySmall,), Text( '\$ 1,234,567.89', style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600), ), const SizedBox(height: kDefaultPadding * 1.5), Align( alignment: Alignment.centerRight, child: TextButton.icon( icon: Icon(Icons.visibility_outlined, size: 18, color: colorScheme.secondary), label: Text( 'Ver Detalles', style: textTheme.labelMedium?.copyWith(color: colorScheme.secondary), ), onPressed: () { ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Navegar a detalles... (TODO)'), duration: Duration(seconds: 1),)); }, style: TextButton.styleFrom(padding: EdgeInsets.zero), ), ) ],), ), ), const SizedBox(height: kDefaultPadding * 2), Center( child: Text( 'Usa la barra inferior para navegar', style: theme.textTheme.bodySmall, textAlign: TextAlign.center, ), ), ], ), );
   }

  Widget _buildPlaceholderPage(BuildContext context, String title) { /* ... (igual que antes) ... */
     final theme = Theme.of(context); return Center( child: Column( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[ Icon( Icons.construction_outlined, size: 80, color: theme.disabledColor,), const SizedBox(height: kDefaultPadding), Text( '$title (En Construcción)', style: theme.textTheme.headlineSmall, textAlign: TextAlign.center,), ],), );
   }

  Widget _buildCalculatorsPageBody(BuildContext context) { /* ... (igual que antes) ... */
     final theme = Theme.of(context); return ListView( padding: const EdgeInsets.all(kDefaultPadding), children: <Widget>[ Padding( padding: const EdgeInsets.only(bottom: kDefaultPadding), child: Text("Calculadoras Financieras", style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)), ), _buildCalculatorListTile( context: context, theme: theme, icon: Icons.percent_outlined, title: 'Interés Simple', routeName: '/interes_simple',), _buildCalculatorListTile( context: context, theme: theme, icon: Icons.trending_up_outlined, title: 'Interés Compuesto', routeName: '/interes_compuesto',), _buildCalculatorListTile( context: context, theme: theme, icon: Icons.calendar_today_outlined, title: 'Anualidades', routeName: '/anualidades',), _buildCalculatorListTile( context: context, theme: theme, icon: Icons.receipt_long_outlined, title: 'Amortización', routeName: '/amortizacion',), ],);
   }
   Widget _buildCalculatorListTile({ required BuildContext context, required ThemeData theme, required IconData icon, required String title, required String routeName, }) { /* ... (igual que antes) ... */ return ListTile( leading: Icon(icon, color: theme.colorScheme.secondary), title: Text(title, style: theme.textTheme.titleMedium), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () => Navigator.pushNamed(context, routeName), ); }


  // --- Contenido Pestaña "Perfil" MODIFICADO para navegar a Editar ---
  Widget _buildProfilePageBody(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _fetchUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) { return const Center(child: CircularProgressIndicator());}
        if (snapshot.hasError) { return Center( child: Padding( padding: const EdgeInsets.all(kDefaultPadding), child: Text( 'Error al cargar el perfil: ${snapshot.error}', style: textTheme.bodyMedium?.copyWith(color: colorScheme.error), textAlign: TextAlign.center,),));}
        // Ahora manejar el caso donde el documento no existe explícitamente
        if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
          return Center( child: Padding( padding: const EdgeInsets.all(kDefaultPadding), child: Text( 'No se encontró el perfil del usuario en Firestore.', style: textTheme.bodyMedium?.copyWith(color: Colors.orange[800]), textAlign: TextAlign.center,),));
        }

        // Datos cargados
        final userData = snapshot.data!.data(); // Sabemos que existe y tiene data()
        // Usar ?? para proporcionar valores por defecto si los campos faltan en Firestore
        final String name = userData?['name'] ?? 'Actualiza tu nombre';
        final String email = userData?['email'] ?? user?.email ?? 'N/A';
        final String idType = userData?['idType'] ?? '--';
        final String idNumber = userData?['idNumber'] ?? 'Actualiza tu ID';

        return ListView( padding: const EdgeInsets.all(kDefaultPadding), children: [
             Center( child: CircleAvatar( radius: 45, backgroundColor: colorScheme.primaryContainer ?? colorScheme.primary.withOpacity(0.1), child: Text( name.isNotEmpty && name != 'Actualiza tu nombre' ? name[0].toUpperCase() : 'U', style: textTheme.displaySmall?.copyWith(color: colorScheme.primary),),),),
             const SizedBox(height: kDefaultPadding),
             Center(child: Text(name, style: textTheme.headlineSmall)),
             const SizedBox(height: kDefaultPadding / 2),
             Center(child: Text(email, style: textTheme.bodyMedium)),
             const SizedBox(height: kDefaultPadding / 2),
             Center(child: Text('$idType $idNumber', style: textTheme.bodyMedium)),
             const SizedBox(height: kDefaultPadding * 1.5),

             // --- Botón Editar Perfil (CON NAVEGACIÓN ACTIVADA) ---
             Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Editar Perfil'),
                  onPressed: () {
                    // --- NAVEGACIÓN A EditProfilePage ---
                    if (userData != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfilePage(userData: userData)),
                        ).then((_) {
                             // Refrescar datos al volver
                             if (mounted) { setState(() {}); }
                        });
                    } else {
                        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Error: No se pudieron cargar los datos para editar.'), duration: Duration(seconds: 2),));
                    }
                    // --- FIN NAVEGACIÓN ---
                  },
                   style: ElevatedButton.styleFrom( minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5, vertical: kDefaultPadding / 2), textStyle: textTheme.labelMedium,),
                ),
             ),
             Divider(height: kDefaultPadding * 2.5, thickness: 1, color: theme.dividerTheme.color),

             // --- Sección Configuración ---
             Text('Configuración', style: textTheme.titleMedium?.copyWith(color: colorScheme.secondary)),
             const SizedBox(height: kDefaultPadding / 2),
             ListTile( leading: Icon(Icons.security_outlined, color: colorScheme.primary), title: Text('Seguridad y Biometría', style: textTheme.titleMedium), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () { Navigator.push( context, MaterialPageRoute(builder: (context) => const SettingsPage()),); },),
             Divider(indent: 50, endIndent: 10, color: theme.dividerTheme.color?.withOpacity(0.5)),
             ListTile( leading: Icon(Icons.notifications_outlined, color: colorScheme.primary), title: Text('Notificaciones', style: textTheme.titleMedium), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () { /* TODO */ },),
             ListTile( leading: Icon(Icons.help_outline, color: colorScheme.primary), title: Text('Ayuda y Soporte', style: textTheme.titleMedium), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () { /* TODO */ },),
           ],
         );
       },
     );
   }
   // --- FIN MÉTODO MODIFICADO ---


  // --- Método Build Principal ---
  @override
  Widget build(BuildContext context) { /* ... (igual que antes) ... */
     final theme = Theme.of(context);
     final List<Widget> pageOptions = <Widget>[ _buildHomePageBody(context), _buildPlaceholderPage(context, 'Transferencias'), _buildPlaceholderPage(context, 'Pagos'), _buildCalculatorsPageBody(context), _buildProfilePageBody(context), ]; // Se usa el método modificado
     return Scaffold( backgroundColor: theme.scaffoldBackgroundColor, appBar: AppBar( title: _buildAppBarTitle(context), centerTitle: true, automaticallyImplyLeading: false, actions: <Widget>[ _buildSignOutButton(context), const SizedBox(width: kDefaultPadding / 2),], ),
        body: IndexedStack( index: _selectedIndex, children: pageOptions,),
        bottomNavigationBar: BottomNavigationBar( items: const <BottomNavigationBarItem>[ BottomNavigationBarItem( icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio',), BottomNavigationBarItem( icon: Icon(Icons.swap_horiz_outlined), activeIcon: Icon(Icons.swap_horiz), label: 'Transferir',), BottomNavigationBarItem( icon: Icon(Icons.payment_outlined), activeIcon: Icon(Icons.payment), label: 'Pagos',), BottomNavigationBarItem( icon: Icon(Icons.calculate_outlined), activeIcon: Icon(Icons.calculate), label: 'Calculos',), BottomNavigationBarItem( icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil',),],
           currentIndex: _selectedIndex, onTap: (int index) { setState(() { _selectedIndex = index; }); }, ), );
   }
} // Fin _HomePageState