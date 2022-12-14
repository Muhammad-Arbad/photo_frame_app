import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_frame/views/home_page.dart';
import 'package:photo_frame/widgets/categories_list.dart';
import 'package:photo_frame/widgets/custom_appbar.dart';
import 'package:photo_frame/widgets/my_creation_list.dart';

import 'widgets/divider.dart';

void main() {
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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actions: [
              TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Row(
                    children: [Text("Start"), Icon(Icons.arrow_forward_sharp)],
                  ))
            ],
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text("Photo Frames"),
            flexibleSpace: Custom_AppBar(),
          ),
          body: HomePage(),
        ),
      ),
    );
  }
}
