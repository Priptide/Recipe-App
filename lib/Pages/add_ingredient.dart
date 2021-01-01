import 'package:RecipeApp/Classes/Ingredients.dart';
import 'package:RecipeApp/Classes/user.dart';
import 'package:RecipeApp/FirespacePages/database.dart';
import 'package:RecipeApp/Pages/pantry_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddIngredient extends StatefulWidget {
  @override
  AddIngredient();
  _AddIngredientState createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  DatabaseService repository = DatabaseService();

  Ingredient localIngredient = new Ingredient(
    'Blank',
    size: 0,
    unit: 'None',
  );

  static final Map<int, String> mapIng = {
    0: "Flower",
    1: "Sugar",
    2: "Milk",
    3: "Honey",
    4: "Olive Oil",
    5: "Caster Sugar",
    6: "Black Olives",
  };

  static final Map<int, String> mapUnit = {
    0: "g",
    1: "litre",
    2: "tbsp",
    3: "tsp",
  };

  final List<DropdownMenuItem<String>> ingredients = [];

  final List<DropdownMenuItem<String>> units = [];

  final myController = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void initState() {
    for (var i = 0; i < mapIng.length; i++) {
      ingredients.add(DropdownMenuItem(
        child: Text(mapIng[i]),
        value: mapIng[i],
      ));
    }

    for (var i = 0; i < mapUnit.length; i++) {
      units.add(DropdownMenuItem(
        child: Text(mapUnit[i]),
        value: mapUnit[i],
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Ingredient',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 23.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Text(
                  'Add New Ingredient',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Ingredient: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SearchableDropdown.single(
                    hint: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Select Ingredient'),
                    ),
                    items: ingredients,
                    searchHint: 'Select Ingredient',
                    onChanged: (String value) {
                      setState(
                        () {
                          localIngredient.name = value;
                        },
                      );
                    },
                    onClear: () {
                      localIngredient.name = 'Blank';
                    },
                    //isExpanded: true,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Unit: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SearchableDropdown.single(
                    hint: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Select Unit'),
                    ),
                    items: units,
                    searchHint: 'Select Unit',
                    onChanged: (value) {
                      setState(
                        () {
                          localIngredient.unit = value;
                        },
                      );
                    },
                    onClear: () {
                      localIngredient.unit = 'None';
                    },
                    //isExpanded: true,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Size: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: myController,
                      keyboardType: TextInputType.number,
                      decoration:
                          new InputDecoration(labelText: "Enter Amount"),
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
              FlatButton.icon(
                onPressed: () {
                  setState(() {
                    //Add Size
                    try {
                      localIngredient.size = int.parse(myController.text);
                    } catch (e) {
                      print(e);
                    }
                    //Check All Parts Are Correct.
                    if (localIngredient.name != 'Blank' &&
                        localIngredient.size > 0 &&
                        localIngredient.unit != 'None') {
                      DatabaseService repository = DatabaseService(
                        uid: user.uid,
                        ingredCollection: Firestore.instance
                            .collection("UserData")
                            .document(user.email)
                            .collection("Ingredients"),
                        docPlacement: Firestore.instance
                            .collection("UserData")
                            .document(user.email)
                            .collection("Ingredients")
                            .document(localIngredient.name),
                      );

                      print('Ingredient Complete');
                      Ingredient newIng = Ingredient(localIngredient.name,
                          unit: localIngredient.unit,
                          size: localIngredient.size);
                      repository.addIngred(newIng);
                      //Move Back To Pantry Page.
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  PantryPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 1.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  end: const Offset(0, 1.0),
                                  begin: Offset.zero,
                                ).animate(secondaryAnimation),
                                child: child,
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      print('Ingredient Failed');
                      //TODO: Add Smarter + On Screen Errors
                    }
                  });
                },
                icon: Icon(Icons.check),
                label: Text('Add Item'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
