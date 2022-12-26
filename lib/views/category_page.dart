import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_frame/views/single_frame.dart';
import 'package:photo_frame/widgets/categories_list_verticle.dart';

class CategoryPage extends StatefulWidget {
  String frameLocationName;
  String categoryName;
  Color bgColor;

  CategoryPage(
      {Key? key, required this.frameLocationName, required this.categoryName,required this.bgColor})
      : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<String> imageNames = [];

  @override
  void initState() {
    loadFrames();
    // TODO: implement initState
    super.initState();
  }

  void loadFrames() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    log(json.decode(manifestContent).toString());
    final imagePaths = manifestMap.keys
        .where((String key) => key.contains(
            'assets/categories/frames/' + widget.frameLocationName + '/'))
        .toList();
    imageNames = imagePaths;
    setState(() {});
    print("Getting Length = " + imageNames.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.bgColor.withOpacity(0.6),
        centerTitle: true,
        title: Text(widget.categoryName),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding:  EdgeInsets.all(8.0),
              child: SingleCatlog(changeFramesCategory: (frameLocationName){
                widget.frameLocationName = frameLocationName;
                loadFrames();
              },changeFramesCategoryName: (framesCategoryName){
                widget.categoryName = framesCategoryName;
              },
              changeAppBarColor: (color){widget.bgColor= color;},
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FramesGrid(
                  imageNames: imageNames,
                  frameLocationName: widget.frameLocationName,
                  noTxtColor:widget.bgColor),
              //child: Container(color: Colors.red,),
            ),
          ),
        ],
      ),
    );
  }
}

class FramesGrid extends StatelessWidget {
  List<String> imageNames;
  String frameLocationName;
  Color noTxtColor;

  FramesGrid(
      {Key? key, required this.imageNames, required this.frameLocationName,required this.noTxtColor})
      : super(key: key);

  final scrollController = ScrollController(initialScrollOffset: 0);

  @override
  Widget build(BuildContext context) {

    print("");
    return Scrollbar(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child:imageNames.length!=0? GridView.count(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(
            imageNames.length,
            (index) => singleFrame(context, imageNames[index], frameLocationName),
          ),
        ):
        Center(child: Text("No Frame Found",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: noTxtColor),),),
      ),
    );
  }

  Widget singleFrame(BuildContext context, imageNames, frameLocationName) {
    return InkWell(
      highlightColor: Colors.lightBlueAccent.withOpacity(0.3),
      splashColor: Colors.blue,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleFrame(
                    imageNames: imageNames,
                    frameLocationName: frameLocationName)));
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(imageNames),
              // fit: BoxFit.cover
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
