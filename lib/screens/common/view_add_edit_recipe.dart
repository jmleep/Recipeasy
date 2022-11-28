import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/data/model/recipe_photo.dart';

class ViewAddEditRecipe extends StatefulWidget {
  @override
  ViewAddEditRecipeState createState() => ViewAddEditRecipeState();
}

class ViewAddEditRecipeState<T extends ViewAddEditRecipe> extends State<T> {
  var activePhoto = 0;
  late ScrollController previewScrollController;

  setActivePhoto(int index, List<RecipePhoto> recipePhotos) {
    if (index < 0 || index >= recipePhotos.length) {
      return;
    }

    HapticFeedback.selectionClick();
    setState(() {
      activePhoto = index;
    });
  }

  triggerScrollAnimation(double position) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      previewScrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  swipeActivePhoto(DragEndDetails details, List<RecipePhoto> recipePhotos) {
    final double photoWidth = 75.0;
    final double separatorWidth = 10.0;
    final double totalWidth = photoWidth + separatorWidth;

    if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
      if (activePhoto > 2 ||
          previewScrollController.position.pixels !=
              previewScrollController.position.minScrollExtent) {
        triggerScrollAnimation((activePhoto - 1) * totalWidth);
      }

      setActivePhoto(activePhoto + 1, recipePhotos);
    } else {
      triggerScrollAnimation((activePhoto - 2) * totalWidth);

      setActivePhoto(activePhoto - 1, recipePhotos);
    }
  }

  @override
  void initState() {
    super.initState();
    previewScrollController = new ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    previewScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
