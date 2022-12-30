import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_frame/views/splash_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily:"12",
          primarySwatch: Colors.lightBlue,
          scrollbarTheme: ScrollbarThemeData(
              //crossAxisMargin: -10,
              isAlwaysShown: true,
              thickness: MaterialStateProperty.all(3),
              thumbColor: MaterialStateProperty.all(Colors.lightBlueAccent),
              radius: const Radius.circular(10),
              minThumbLength: 100
          )
      ),
      debugShowCheckedModeBanner: false,
      //home: HomePage()
      home: SplashScreen()


      // Container(
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage("assets/bg3.jpg"),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      //   child: Scaffold(
      //     backgroundColor: Colors.transparent,
      //     appBar: AppBar(
      //       centerTitle: true,
      //       // actions: [
      //       //   TextButton(
      //       //       onPressed: () {
      //       //         // Navigator.push(
      //       //         //     context, MaterialPageRoute(builder: (context) => CategoryPage(frameLocationName:GlobalItems().categoriesList.first.frameLocationName,
      //       //         //     categoryName: GlobalItems().categoriesList.first.name,
      //       //         //     bgColor:GlobalItems().categoriesList.first.bgColor
      //       //         // )));
      //       //       },
      //       //       style: ButtonStyle(
      //       //         foregroundColor: MaterialStateProperty.all(Colors.white),
      //       //       ),
      //       //       child: Row(
      //       //         children: [Text("Start"), Icon(Icons.arrow_forward_sharp)],
      //       //       ))
      //       // ],
      //       backgroundColor: Colors.transparent,
      //       elevation: 0.0,
      //       title: Text("Photo Frames"),
      //       flexibleSpace: Custom_AppBar(),
      //     ),
      //      body: HomePage(),
      //     //body: SplashScreen(),
      //   ),
      // ),
    );
  }
}
