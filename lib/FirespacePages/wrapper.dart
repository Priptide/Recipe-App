import 'package:RecipeApp/Classes/user.dart';
import 'package:RecipeApp/Pages/home_page.dart';
import 'package:RecipeApp/Pages/signIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //Return Home Or Authenticate Widget
    if (user != null) {
      return HomePage();
    } else {
      return SignInPage();
    }
  }
}
