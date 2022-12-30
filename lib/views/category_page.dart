import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_frame/ad_mobs_service/ad_mob_service.dart';
import 'package:photo_frame/views/single_frame.dart';
import 'package:photo_frame/widgets/categories_list_verticle.dart';

class CategoryPage extends StatefulWidget {
  String frameLocationName;
  String categoryName;
  Color bgColor;
  String icon;
  BannerAd? bannerAd;

  CategoryPage(
      {Key? key, required this.frameLocationName, required this.categoryName,required this.bgColor,required this.icon})
      : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<String> imageNames = [];


  @override
  void initState() {
    _createBannerAd();
    loadFrames();
    // TODO: implement initState
    super.initState();
  }


  void _createBannerAd() {
    widget.bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId.toString(),
        listener: AdMobService.bannerAdListener,
        request: const AdRequest())
      ..load();


  }

  void loadFrames() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // log(json.decode(manifestContent).toString());
    final imagePaths = manifestMap.keys
        .where((String key) => key.contains(
            'assets/categories/frames/' + widget.frameLocationName + '/'))
        .toList();
    imageNames = imagePaths;
    setState(() {});
    // print("Getting Length = " + imageNames.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.bgColor.withOpacity(0.6),
        centerTitle: true,
        title: Row(
          children: [
            Expanded(child: Text(widget.categoryName,style: TextStyle(fontFamily: "13",fontSize: 25)),),
            Expanded(child: ImageIcon(
              AssetImage(widget.icon),
              size: 40,
              color: Colors.black,
            ),)
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding:  EdgeInsets.all(8.0),
              child: SingleCatlog(
                changeIcon: (iconPath){widget.icon = iconPath;},
                changeFramesCategory: (frameLocationName){
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
      bottomNavigationBar: widget.bannerAd == null
          ? null
          : Container(
        //margin: const EdgeInsets.only(bottom: 12),
        height:60,
        child: AdWidget(ad: widget.bannerAd!),
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

    // print("");
    return Scrollbar(
      controller: scrollController,
      child:
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child:

        imageNames.length!=0?
        GridView.count(
          childAspectRatio: 0.6,
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
      // child: Image.asset(
      //     imageNames,
      //     //scale: 1.0,
      //   fit: BoxFit.fitHeight,
      // ),


      child: Container(
        child: Image(image: AssetImage(imageNames),fit: BoxFit.fitHeight,),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage(imageNames),
        //       // fit: BoxFit.cover
        //       fit: BoxFit.cover),
        // ),
      ),
    );
  }
}
