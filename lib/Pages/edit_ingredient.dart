import 'package:RecipeApp/Classes/Ingredients.dart';
import 'package:RecipeApp/Classes/user.dart';
import 'package:RecipeApp/FirespacePages/database.dart';
import 'package:RecipeApp/Pages/pantry_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class EditIngredient extends StatefulWidget {
  final DocumentSnapshot docsnap;
  final DatabaseService repo;
  final DocumentReference documentReference;
  @override
  EditIngredient({
    this.docsnap,
    this.repo,
    this.documentReference,
  });
  _EditIngredientState createState() => _EditIngredientState(
        documentSnapshot: docsnap,
        repository: repo,
      );
}

class _EditIngredientState extends State<EditIngredient> {
  final myController = TextEditingController();

  final DatabaseService repository;

  final DocumentReference documentReference;

  final DocumentSnapshot documentSnapshot;

  Ingredient localIngredient;

  _EditIngredientState({
    this.documentSnapshot,
    this.repository,
    this.documentReference,
  });

  static final Map<int, String> mapUnit = {
    0: "g",
    1: "litre",
    2: "tbsp",
    3: "tsp",
  };

  final List<DropdownMenuItem<String>> units = [];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void initState() {
    for (var i = 0; i < mapUnit.length; i++) {
      units.add(DropdownMenuItem(
        child: Text(mapUnit[i]),
        value: mapUnit[i],
      ));
    }
    localIngredient = Ingredient.fromSnapshot(documentSnapshot);
    super.initState();
  }

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Ingredient',
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
                  'Edit Ingredient: ' + localIngredient.name,
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
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(localIngredient.name),
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
                      child: Text(localIngredient.unit),
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
                    'New Size: ',
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
                      decoration: new InputDecoration(
                          labelText:
                              'Old Value: ' + localIngredient.size.toString()),
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
                    try {
                      localIngredient.size = int.parse(myController.text);
                    } catch (e) {
                      print(e);
                    }

                    if (localIngredient.unit != 'None' &&
                        localIngredient.size > 0) {
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

                      repository.updateIngred(localIngredient);
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
                      //TO-DO: Add Smarter + On Screen Errors
                    }
                  });
                },
                icon: Icon(Icons.refresh),
                label: Text('Update Item'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
