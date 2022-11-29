import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/buttons/button_recipeasy.dart';

class SettingsScreen extends StatelessWidget {
  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RecipeAppBar(allowBack: true, title: 'Settings'),
      body: Column(
        children: [
          Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RoundedButton(
              borderColor: Theme.of(context).colorScheme.secondary,
              textColor: Colors.white,
              fillColor: Colors.grey[800]!,
              onPressed: () => signOut(context),
              buttonText: 'Sign out',
              leftPadding: 50,
              rightPadding: 50,
            )
          ]),
          Container(padding: EdgeInsets.only(bottom: 50))
        ],
      ),
    );
  }
}
