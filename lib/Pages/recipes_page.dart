import 'package:RecipeApp/Classes/SideDrawerWidget.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  //TODO Workout All Boolean values

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 23.0,
          ),
        ),
        centerTitle: true,
      ),
      drawer: SideDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.settings,
          size: 30,
        ),
        onPressed: () =>
            showDialog(context: context, builder: (context) => SettingsForm()),
      ),
    );
  }
}

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  bool searchAllIngredient = false;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(
              value: searchAllIngredient,
              onChanged: (val) => setState(() {
                searchAllIngredient = val;
              }),
            )
          ],
        ),
      ],
    );
  }
}
