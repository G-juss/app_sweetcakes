import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

// Importa tus nuevas pantallas
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];

    return MaterialApp(
      
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              AuthStateChangeAction<UserCreated>((context, state) {
                Navigator.of(context, rootNavigator: true).pushReplacementNamed('/home');
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.of(context, rootNavigator: true).pushReplacementNamed('/home');
              }),
            ],
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            providers: providers,
            actions: [
              SignedOutAction((context) {
                Navigator.of(context, rootNavigator: true).pushReplacementNamed('/sign-in');
              }),
            ],
          );
        },
        
        '/home': (context) => HomeScreen(),

        
        '/cart': (context) => CartScreen(),
      },
    );
  }
}
