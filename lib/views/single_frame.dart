import 'dart:io';
import 'dart:typed_data';



import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_frame/widgets/moveable_widget.dart';

class SingleFrame extends StatefulWidget {
  String imageNames;

  SingleFrame({Key? key, required this.imageNames}) : super(key: key);

  @override
  State<SingleFrame> createState() => _SingleFrameState();
}

class _SingleFrameState extends State<SingleFrame> {
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  XFile? selectedImage;
  File? imgFile;
  final ImagePicker picker = ImagePicker();
  GlobalKey _globalKey =  GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Photo Frame"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 80,
          child: RepaintBoundary(
            key: _globalKey,
            child: Stack(
              children: [
                Positioned.fill(
                  child: selectedImage==null?Container():MoveableWidget(
                    //item: Image.asset("assets/arbad.jpg"),
                    //item: Image.file(File(selectedImage!.path)),
                    item: Image.file(File(selectedImage!.path)),
                  ),
                ),
                IgnorePointer(
                  child: Container(
                    // width: double.maxFinite,
                    // height: double.maxFinite,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(widget.imageNames),
                      ),
                    ),
                    //child: Image.asset(imageNames,fit: BoxFit.cover,),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet:  Container(
        height: MediaQuery.of(context).size.height*0.08,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white // Background color
                ),
                onPressed: (){},
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter_frames_outlined,color: Colors.black),
                    Text("Frames",style: TextStyle(color: Colors.black),)
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.white // Background color
                ),
                onPressed: (){
                  getImage(ImageSource.gallery);
                },
                //color: Colors.red,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_outlined,color: Colors.black),
                    Text("Image",style: TextStyle(color: Colors.black),)
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.white // Background color
                ),
                onPressed: (){},
                //color: Colors.red,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline,color: Colors.black),
                    Text("Sticker",style: TextStyle(color: Colors.black),)
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.white // Background color
                ),
                onPressed: (){

                  _capturePng();
                },
                //color: Colors.red,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_alt_outlined,color: Colors.black),
                    Text("Save",style: TextStyle(color: Colors.black),)
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      selectedImage = img;
    });
  }

  Future<Uint8List> _capturePng() async {
    //try
    {
      print('inside');
      RenderRepaintBoundary boundary =
      _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      //File convertToFile(XFile xFile) => File(xFile.path);




      //imgFile = await File('my_image.jpg').writeAsBytes(pngBytes);
      GallerySaver.saveImage(selectedImage!.path, albumName: "New Album");
      setState(() {});
      return pngBytes;
    }
    // catch (e) {
    //   print(e);
    // }
  }


}
