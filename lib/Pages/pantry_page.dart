import 'package:RecipeApp/Classes/Ingredients.dart';
import 'package:RecipeApp/Classes/SideDrawerWidget.dart';
import 'package:RecipeApp/Classes/user.dart';
import 'package:RecipeApp/FirespacePages/database.dart';
import 'package:RecipeApp/Pages/edit_ingredient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_ingredient.dart';

class PantryPage extends StatefulWidget {
  @override
  _PantryPageState createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  List<Ingredient> ingredientList = [];
  @override
  void initState() {
    //ingredientList.add(
    //Ingredient(name: 'Flower', unit: 'g', size: 300),
    //    );
    super.initState();
  }

  Widget returnIngred(BuildContext cxt, DocumentSnapshot ingData) {
    final user = Provider.of<User>(cxt);
    final DatabaseService repository = DatabaseService(
      uid: user.uid,
      ingredCollection: Firestore.instance
          .collection("UserData")
          .document(user.email)
          .collection("Ingredients"),
    );
    final ing = Ingredient.fromSnapshot(ingData);
    if (ing == null || ing.name == null || user == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Card(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ing.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    ing.size.toString() + ' ' + ing.unit,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  EditIngredient(
                            repo: repository,
                            docsnap: ingData,
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 1.0),
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
                    },
                    icon: Icon(Icons.edit),
                    label: Text('Edit'),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      setState(() {
                        repository.removeIngred(ingData);
                      });
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Delete Item'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => returnIngred(context, data)).toList(),
    );
  }

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final DatabaseService repository = DatabaseService(
      uid: user.uid,
      ingredCollection: Firestore.instance
          .collection("UserData")
          .document(user.email)
          .collection("Ingredients"),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pantry',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 23.0,
          ),
        ),
        centerTitle: true,
      ),
      drawer: SideDrawer(),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return _buildList(context, snapshot.data.documents);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddIngredient(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 1.0),
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
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
