
import 'package:flutter/material.dart';
import 'package:photo_frame/widgets/categories_list.dart';
import 'package:photo_frame/widgets/divider.dart';
import 'package:photo_frame/widgets/home_page_icon.dart';
import 'package:photo_frame/widgets/my_creation_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height:MediaQuery.of(context).size.height*0.08,),
        CustomDivider(centerOfDivider:Column(children: [HomePageIcon(iconName: Icons.widgets),SizedBox(height: 5,),Text("Categories",)],)),
        SizedBox(height:MediaQuery.of(context).size.height*0.03,),
        SizedBox(
          height: MediaQuery.of(context).size.height*0.30,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            // child: CategoriesGrid(scrollController: scrollController),
            child: CategoriesGrid(),
          ),
        ),
        SizedBox(height:MediaQuery.of(context).size.height*0.08,),
        CustomDivider(centerOfDivider: Column(children: [HomePageIcon(iconName: Icons.games_sharp),SizedBox(height: 5,),Text("My Stugg")],)),
        SizedBox(height:MediaQuery.of(context).size.height*0.03,),
        SizedBox(
          height:  MediaQuery.of(context).size.height*0.15,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyCreationGrid(),
          ),
        ),
      ],
    );
  }
}
