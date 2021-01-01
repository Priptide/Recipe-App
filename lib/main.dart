import 'package:RecipeApp/FirespacePages/auth.dart';
import 'package:RecipeApp/FirespacePages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Classes/user.dart';
//import 'Ingredients.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().userStream,
      child: MaterialApp(
          theme: ThemeData(
            canvasColor: Colors.white,
            primaryColor: Colors.black,
          ),
          home: new Wrapper()),
    );
  }
}
