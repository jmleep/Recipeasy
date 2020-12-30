import 'package:my_recipes/model/model_list_base.dart';

class Photo extends ModelListBase {
  Photo({int id, int recipeId, String value})
      : super(id: id, recipeId: recipeId, value: value);
}
