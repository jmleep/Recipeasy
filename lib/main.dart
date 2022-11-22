import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/screens/screen_home.dart';
import 'package:my_recipes/theme/theme.dart';
import 'package:my_recipes/theme/widget_styles.dart';

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
      title: 'Recipeasy',
      theme: RecipeasyTheme.getLightThemeData(),
      darkTheme: RecipeasyTheme.getDarkThemeData(),
      initialRoute: initialRoute,
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            headerBuilder: (context, constraints, shrinkOffset) => Container(
                alignment: Alignment.topCenter,
                child: Text("Recipeasy",
                    style: ReusableStyleWidget.appBarTextStyle(context))),
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
