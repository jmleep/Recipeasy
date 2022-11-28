import 'dart:convert';
import 'dart:typed_data';

class RecipePhoto {
  final int id;
  final int recipeId;
  final Uint8List image;
  bool isPrimary;

  RecipePhoto({this.id, this.recipeId, this.image, this.isPrimary = false});

  Map<String, dynamic> toMap(int recipeId) {
    Map<String, dynamic> values = new Map();

    if (this.image == null) throw "NULL IMAGE EXCEPTION";

    values.addAll({
      'recipe_id': recipeId,
      'image': base64.encode(this.image),
      'is_primary': this.isPrimary ? 1 : 0
    });

    if (this.id != null) {
      values['id'] = this.id;
    }

    return values;
  }
}
