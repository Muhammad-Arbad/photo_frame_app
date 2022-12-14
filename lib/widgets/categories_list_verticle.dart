import 'package:flutter/material.dart';
import 'package:photo_frame/global_items/global_items.dart';
import 'package:photo_frame/models/categoriesModel.dart';


class SingleCatlog extends StatelessWidget {
  const SingleCatlog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 1,
      mainAxisSpacing: 10,
      children: List.generate(
        GlobalItems().categoriesList.length,
            (index) => singleCategory(GlobalItems().categoriesList[index], context),
      ),
    );
  }

  Widget singleCategory(CategoriesModel categoriesList, BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image:  AssetImage(categoriesList.imagePath),
          // ),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10), topLeft: Radius.circular(10)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                categoriesList.bgColor,
                categoriesList.bgColor.withOpacity(0.5)
              ]),
        ),
        // color: Colors.amber,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(categoriesList.imagePath),
              size: 40,
              color: Colors.white,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              categoriesList.name,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}