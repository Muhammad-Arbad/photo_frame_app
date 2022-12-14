import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_frame/global_items/global_items.dart';
import 'package:photo_frame/models/categoriesModel.dart';
import 'package:photo_frame/views/single_frame.dart';
import 'package:photo_frame/widgets/categories_list_verticle.dart';



class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  List<String> imageNames = [];

  @override
  void initState(){
    loadFrames();
    // TODO: implement initState
    super.initState();
  }

  void loadFrames()async{
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/'))
        .where((String key) => key.contains('categories/'))
        .where((String key) => key.contains('frames/'))
        .where((String key) => key.contains('.png'))
        .toList();
    imageNames = imagePaths;
    setState(() {});
    print("Getting Length = "+imageNames.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(""),

      ),
      body: Row(
        children: [
          Expanded(flex :1,child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleCatlog(),
          )),
          Expanded(flex :2,child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: FramesGrid(imageNames: imageNames,),
            //child: Container(color: Colors.red,),
          )),
        ],
      ),
    );
  }
}




class FramesGrid extends StatelessWidget {
  List<String> imageNames;
   FramesGrid({Key? key,required this.imageNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: List.generate(
        imageNames.length,
            (index) => singleCategory(context,imageNames[index]),
      ),
    );
  }

  Widget singleCategory(BuildContext context, imageNames) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleFrame(imageNames: imageNames)));
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:  AssetImage(imageNames),
            fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10), topLeft: Radius.circular(10)),
          // gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: <Color>[
          //       categoriesList.bgColor,
          //       categoriesList.bgColor.withOpacity(0.5)
          //     ]),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

             //Image.asset(imageNames)

          ],
        ),
      ),
    );
  }
}

