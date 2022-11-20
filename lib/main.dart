import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/screens/screen_home.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  runApp(MyRecipeApp());
}

class MyRecipeApp extends StatelessWidget {
  String get initialRoute {
    final auth = fba.FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return '/sign-in';
    }

    return '/home';
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Recipes',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(24),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).backgroundColor),
            foregroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor),
          ),
        ),
        primaryColor: Colors.green[500],
        backgroundColor: Colors.white,
        accentColor: Colors.green[700],
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.green[500],
        backgroundColor: Colors.black12,
        accentColor: Colors.green[700],
        brightness: Brightness.dark,
      ),
      initialRoute: initialRoute,
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/home');
              }),
              AuthStateChangeAction<UserCreated>((context, state) {
                Navigator.pushReplacementNamed(context, '/home');
              })
            ],
          );
        },
        '/home': (context) {
          return HomeScreen();
        },
        '/profile': (context) {
          return ProfileScreen(
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
      },
    );
  }
}
