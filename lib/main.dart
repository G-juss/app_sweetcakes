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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Conexion a Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Mensaje de confirmacion
    print("\n-------------------------------------------------------------");
    print("✅ ¡Conectado a la Base de datos! (Firebase Inicializado)");
    print("-------------------------------------------------------------\n");

  } catch (e) {
    // Si falla, imprimirá esto:
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

      // 1. CONFIGURACIÓN DE IDIOMA (ESPAÑOL)
      localizationsDelegates: [
        FirebaseUILocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],

      // 2. TEMA PERSONALIZADO (Diseño Rosita)
      theme: ThemeData(
        primaryColor: const Color(0xFFFF80AB), 
        scaffoldBackgroundColor: const Color(0xFFFFF0F5), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF80AB),
          primary: const Color(0xFFFF80AB),
        ),
        useMaterial3: true,
        
        // Estilo de tarjetas
        cardTheme: CardThemeData( 
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        
        // Estilo de los Inputs (Cajas de texto)
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

      // 3. RUTAS Y NAVEGACIÓN
      // Si hay usuario, va al Home. Si no, al Login.
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      
      routes: {
        // Conectamos tu diseño personalizado
        '/sign-in': (context) => const CustomSignInScreen(),
        
        '/profile': (context) => const UserProfileScreen(),
        '/home': (context) => HomeScreen(),
        '/cart': (context) => CartScreen(),
        '/admin-products': (context) => AdminProductsScreen(),
      },
    );
  }
}