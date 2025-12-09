import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';



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
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/profile',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
                AuthStateChangeAction<UserCreated>((context, state) {
                // Put any new user logic here
                Navigator.of(context, rootNavigator: true).pushReplacementNamed('/profile');
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.of(context, rootNavigator: true).pushReplacementNamed('/profile');
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
      },
    );
  }
}