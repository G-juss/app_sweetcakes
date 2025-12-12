import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

// Importaciones de tus pantallas
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/custom_sign_in_screen.dart';
import 'screens/admin_products_screen.dart';
import 'screens/select_role_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print("\n-------------------------------------------------------------");
    print("✅ ¡Conectado a la Base de datos! (Firebase Inicializado)");
    print("-------------------------------------------------------------\n");
  } catch (e) {
    print("\n❌ Error al conectar con Firebase: $e \n");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SweetCakes',

      // 1) IDIOMA
      localizationsDelegates: const [
        FirebaseUILocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],

      // 2) TEMA
      theme: ThemeData(
        primaryColor: const Color(0xFFFF80AB),
        scaffoldBackgroundColor: const Color(0xFFFFF0F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF80AB),
          primary: const Color(0xFFFF80AB),
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),

      // ✅ 3) ENTRADA: decide si mostrar SelectRole o Home según sesión
      home: const _AuthGate(),

      // ✅ 4) RUTAS
      routes: {
        '/select-role': (context) => const SelectRoleScreen(),
        '/sign-in': (context) => const CustomSignInScreen(),

        '/home': (context) => HomeScreen(),
        '/cart': (context) => CartScreen(),
        '/profile': (context) => const UserProfileScreen(),

        '/admin-products': (context) => const AdminProductsScreen(),
      },
    );
  }
}

// ✅ Decide qué pantalla se muestra dependiendo de si hay sesión
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SelectRoleScreen();
    }

    // Si hay sesión, entra al Home (el admin se maneja al login / guard)
    return HomeScreen();
  }
}
