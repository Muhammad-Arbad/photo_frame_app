import 'package:flutter/material.dart';
import 'package:photo_frame/global_items/global_items.dart';
import 'package:photo_frame/models/categoriesModel.dart';

class MyCreationGrid extends StatelessWidget {
  MyCreationGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      //crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: List.generate(
        GlobalItems().categoriesList.length,
            (index) => singleMyCreation(GlobalItems().categoriesList[index]),
      ),
    );
  }

  Container singleMyCreation(CategoriesModel categoriesList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(
            AssetImage(categoriesList.imagePath),
            size: 40,
            color: Colors.blue,
          ),
          SizedBox(height: 5,),
          Text(
            categoriesList.name,
            style: TextStyle(
                color: Colors.blue
            ),
          ),
        ],
      ),
    );
  }
}
