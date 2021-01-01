import 'package:RecipeApp/Classes/Ingredients.dart';
import 'package:RecipeApp/Classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  //Collection Reference
  final CollectionReference ingredCollection;

  final DocumentReference docPlacement;

  DatabaseService({this.uid, this.ingredCollection, this.docPlacement});

  // //Update User Data
  // Future updateUserData(
  //     Map ingredients, String unitS, Map units, int size) async {
  //   return await ingredCollection.document(uid).setData({
  //     'Ingredients': ingredients,
  //     unitS: units,
  //     'Size': size,
  //   });
  // }

  //Get UserData Stream
  Stream<QuerySnapshot> getStream() {
    return ingredCollection.snapshots();
  }

  Future<void> addIngred(Ingredient ingredient) {
    return docPlacement.setData(ingredient.toJson());
  }

  Future<DocumentReference> removeIngred(DocumentSnapshot ingredient) {
    return ingredCollection.document(ingredient.documentID).delete();
  }

  Future updateIngred(Ingredient ingredient) async {
    try {
      await docPlacement.setData(ingredient.toJson());
      print(ingredient.toJson());
    } catch (e) {
      print(e);
    }
  }

  //GetUserdata
  // Future getUserData(
  //     Map ingredients, String dataName) async {
  //   return await ingredCollection.document(uid).get({
  //   });
  // }
}
