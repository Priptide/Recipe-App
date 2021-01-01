import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  String name;

  int size;

  String unit;

  DocumentReference reference;

  Ingredient(this.name, {this.size, this.unit, this.reference});

  factory Ingredient.fromSnapshot(DocumentSnapshot snapshot) {
    Ingredient newIngred = Ingredient.fromJson(snapshot.data);
    newIngred.reference = snapshot.reference;
    return newIngred;
  }
  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _ingredFromJson(json);

  Map<String, dynamic> toJson() => _ingredToJson(this);
  @override
  String toString() => "Ingredient<$name>";
}

Ingredient _ingredFromJson(Map<String, dynamic> json) {
  return Ingredient(
    json['name'] as String,
    size: json['size'] as int,
    unit: json['unit'] as String,
  );
}

Map<String, dynamic> _ingredToJson(Ingredient instance) => <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'unit': instance.unit,
    };
