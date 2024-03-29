import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/screens/add_edit_recipe/view_model/view_model_add_edit_recipe.dart';
import 'package:my_recipes/screens/home/screen_home.dart';
import 'package:my_recipes/screens/home/view_model/view_model_home.dart';
import 'package:my_recipes/screens/view_recipe_details/view_model/view_model_view_recipe_details.dart';

import 'package:my_recipes/theme/theme.dart';
import 'package:my_recipes/theme/widget_styles.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

setNavBarColor() {
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkMode ? Colors.grey[900] : Colors.white,
      systemNavigationBarIconBrightness:
          isDarkMode ? Brightness.light : Brightness.dark));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  setNavBarColor();
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ViewRecipeViewModel(),
          ),
          ChangeNotifierProvider(create: (context) => AddEditRecipeViewModel()),
          ChangeNotifierProvider(
            create: (context) => HomeViewModel(),
          )
        ],
        child: MaterialApp(
          title: 'Recipeasy',
          theme: RecipeasyTheme.getLightThemeData(),
          darkTheme: RecipeasyTheme.getDarkThemeData(),
          initialRoute: initialRoute,
          routes: {
            '/sign-in': (context) {
              return SignInScreen(
                headerBuilder: (context, constraints, shrinkOffset) =>
                    Container(
                        alignment: Alignment.topCenter,
                        child: Text("Recipeasy",
                            style:
                                ReusableStyleWidget.appBarTextStyle(context))),
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
        ));
  }
}
