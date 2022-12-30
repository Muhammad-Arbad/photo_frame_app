import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_frame/widgets/moveable_widget.dart';
import 'package:text_editor/text_editor.dart';

class SingleFrame extends StatefulWidget {
  String imageNames, frameLocationName;

  SingleFrame(
      {Key? key, required this.imageNames, required this.frameLocationName})
      : super(key: key);

  @override
  State<SingleFrame> createState() => _SingleFrameState();
}

class _SingleFrameState extends State<SingleFrame> {
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  List<String> frames = [];
  List<String> fontsInTextEditor = [];
  List<String> stickersList = [];

  XFile? selectedImage;
  File? imgFile;
  final ImagePicker picker = ImagePicker();
  GlobalKey _globalKey = GlobalKey();
  bool showFrameGrid = false,
      showDeleteButton = false,
      isDeleteButtonActive = false,
      showStickerGrid = false,
      showTextField = false;

  Widget? textOnImage;
  List<Widget> moveableWidgetsOnImage = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    loadFonts();
    loadFrames();
    loadStickers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backButtonPress,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Photo Frame"),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(
              0, 20, 0, MediaQuery.of(context).size.height * 0.08),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 80,
            child: RepaintBoundary(
              key: _globalKey,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: selectedImage == null
                        ? Container()
                        : MoveableWidget(
                            onDragUpdate: (offset) {},
                            onScaleStart: () {},
                            onScaleEnd: (offset) {},
                            item: Image.file(File(selectedImage!.path)),
                          ),
                  ),
                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(widget.imageNames),
                        ),
                      ),
                    ),
                  ),
                  for (int i = 0; i < moveableWidgetsOnImage.length; i++)
                    Positioned.fill(
                      child: MoveableWidget(
                        item: moveableWidgetsOnImage[i],
                        onScaleEnd: (offset) {
                          setState(() {
                            showDeleteButton = false;
                          });
                          // print("From Previous End");

                          if (offset.dy >
                              (MediaQuery.of(context).size.height - 120)) {
                            setState(() {
                              moveableWidgetsOnImage
                                  .remove(moveableWidgetsOnImage[i]);
                            });
                          }
                        },
                        onScaleStart: () {
                          setState(() {
                            showDeleteButton = true;
                          });
                          // print("From Previous Start");
                        },
                        onDragUpdate: (offset) {
                          if (offset.dy >
                              (MediaQuery.of(context).size.height - 120)) {
                            if (!isDeleteButtonActive) {
                              setState(() {
                                isDeleteButtonActive = true;
                              });
                            }
                          } else {
                            setState(() {
                              isDeleteButtonActive = false;
                            });
                          }
                        },
                      ),
                    ),
                  showTextField
                      ? Container(
                          alignment: Alignment.bottomCenter,
                          child: addTextToScreen(),
                        )
                      : IgnorePointer(),
                  showFrameGrid
                      ? Container(
                          alignment: Alignment.bottomCenter,
                          child: selectFramesForScreen(
                              widget.frameLocationName, frames),
                        )
                      : IgnorePointer(),
                  showStickerGrid
                      ? Container(
                          alignment: Alignment.bottomCenter,
                          child: addStickerToScreen(),
                        )
                      : IgnorePointer(),
                  if (showDeleteButton)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Icon(
                        Icons.delete,
                        color: isDeleteButtonActive ? Colors.red : Colors.black,
                        size: isDeleteButtonActive ? 60 : 50,
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white // Background color
                    ),
                onPressed: () {
                  setState(() {
                    showStickerGrid = false;
                    showTextField = false;
                    // showFrameGrid = true;
                    showFrameGrid = !showFrameGrid;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter_frames_outlined,
                        color: showFrameGrid ? Colors.blue : Colors.black),
                    Text(
                      "Frames",
                      style: TextStyle(
                          color: showFrameGrid ? Colors.blue : Colors.black),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white // Background color
                    ),
                onPressed: () {
                  setState(() {
                    showStickerGrid = false;
                    showTextField = false;
                    showFrameGrid = false;
                  });
                  getImage(ImageSource.gallery);
                },
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_outlined, color: Colors.black),
                    Text(
                      "Image",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white // Background color
                    ),
                onPressed: () {
                  //addStickerToScreen();

                  setState(() {
                    showTextField = false;
                    showFrameGrid = false;
                    // showStickerGrid = true;
                    showStickerGrid = !showStickerGrid;
                  });
                },
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: showStickerGrid ? Colors.blue : Colors.black),
                    Text(
                      "Sticker",
                      style: TextStyle(
                          color: showStickerGrid ? Colors.blue : Colors.black),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white // Background color
                    ),
                onPressed: () {
                  setState(() {
                    showFrameGrid = false;
                    showStickerGrid = false;
                    // showTextField = true;
                    showTextField = !showTextField;
                  });

                  // addTextToScreen();
                },
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.text_rotation_angleup_sharp,
                        color: showTextField ? Colors.blue : Colors.black),
                    Text(
                      "Text",
                      style: TextStyle(
                          color: showTextField ? Colors.blue : Colors.black),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white // Background color
                    ),
                onPressed: () {
                  setState(() {
                    showStickerGrid = false;
                    showTextField = false;
                    showFrameGrid = false;
                  });
                  _capturePng(context);
                },
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_alt_outlined, color: Colors.black),
                    Text(
                      "Save",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    // print("Img Path"+img!.path);

    setState(() {
      selectedImage = img;
    });
  }

  void _capturePng(BuildContext context) async {
    final RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    //final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    //create file
//PAth/data/user/0/com.example.photo_frame/cache/baby2022-12-28 17:48:14.144455.png
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String fullPath =
        '$dir/' + widget.frameLocationName + '${DateTime.now()}.png';
    print(dir);
    File capturedFile = File(fullPath);
    await capturedFile.writeAsBytes(pngBytes);
    print("Captured Path" + capturedFile.path);

    await GallerySaver.saveImage(capturedFile.path,
            albumName: widget.frameLocationName, toDcim: true)
        //await GallerySaver.saveImage(capturedFile.path)
        .then((value) {
      if (value == true) {
        Fluttertoast.showToast(
            msg: "Image saved Successfully", backgroundColor: Colors.green);
      } else {
        Fluttertoast.showToast(
            msg: "Failed to save", backgroundColor: Colors.red);
      }
    });
  }

  addStickerToScreen() {
    return Container(
      padding: EdgeInsets.only(bottom: 5, top: 5),
      height: MediaQuery.of(context).size.height * 0.15,
      color: Colors.black,
      child: StickersGrid(
          StickersList: stickersList,
          addStickerToScreen: (imgName) {
            setState(() {
              // print(imgName);
              moveableWidgetsOnImage.add(Image.asset(imgName));
            });
          }),
    );
  }

  addTextToScreen() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.9),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      height: MediaQuery.of(context).size.height / 2,
      child: TextEditor(
        fonts: [
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13'
        ],
        maxFontSize: 50,
        textStyle: TextStyle(fontSize: 25),
        decoration: EditorDecoration(
          doneButton: Container(
            decoration:
                BoxDecoration(color: Colors.black, shape: BoxShape.circle),
            child: Icon(
              Icons.check,
              color: Colors.green,
              size: 50,
            ),
          ),
          fontFamily: Icon(Icons.title, color: Colors.white),
        ),
        onEditCompleted: (TextStyle, TextAlign, String) {
          textOnImage = Text(String, style: TextStyle);
          setState(() {
            showTextField = false;
            moveableWidgetsOnImage.add(textOnImage!);
          });
        },
      ),
    );
  }

  selectFramesForScreen(String frameLocationName, List<String> frames) {
    return Container(
      padding: EdgeInsets.only(bottom: 5, top: 5),
      height: MediaQuery.of(context).size.height * 0.18,
      color: Colors.black,
      child: FramesGrid(
        frameLocationName: frameLocationName,
        frames: frames,
        changeFrame: (frameName) {
          setState(() {
            widget.imageNames = frameName;
          });
        },
      ),
    );
  }

  void loadFrames() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final framesPath = manifestMap.keys
        .where((String key) => key.contains(
            'assets/categories/frames/' + widget.frameLocationName + '/'))
        .toList();
    frames = framesPath;
  }

  void loadStickers() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final stickersPath = manifestMap.keys
        .where((String key) => key.contains('assets/stickers/'))
        .toList();
    stickersList = stickersPath;
  }

  void loadFonts() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final fontsPath = manifestMap.keys
        .where((String key) => key.contains('assets/fonts'))
        .toList();
    fontsInTextEditor = fontsPath;

    // print("Number of Fonts = "+fontsInTextEditor.length.toString());
  }

  Future<bool> backButtonPress() async {
    if (showStickerGrid == true ||
        showTextField == true ||
        showFrameGrid == true) {
      setState(() {
        showStickerGrid = false;
        showTextField = false;
        showFrameGrid = false;
      });

      return await false;
    } else
      return await true;
  }
}

class FramesGrid extends StatefulWidget {
  String frameLocationName;
  List<String> frames;
  void Function(String) changeFrame;

  FramesGrid(
      {Key? key,
      required this.frameLocationName,
      required this.frames,
      required this.changeFrame})
      : super(key: key);

  @override
  State<FramesGrid> createState() => _FramesGridState();
}

class _FramesGridState extends State<FramesGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      mainAxisSpacing: 5,
      childAspectRatio: 1.5,
      //crossAxisSpacing: 10,
      children: List.generate(
        widget.frames.length,
        (index) => singleFrame(context, widget.frames[index]),
      ),
    );
  }

  Widget singleFrame(BuildContext context, imageNames) {
    return GestureDetector(
      onTap: () {
        widget.changeFrame(imageNames);
      },
      child: Container(
        color: Colors.white,
        child: Image(
          image: AssetImage(imageNames),
        ),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   image: DecorationImage(
        //       image:  AssetImage(imageNames),
        //       fit: BoxFit.contain
        //   ),
        // ),
      ),
    );
  }
}

class StickersGrid extends StatefulWidget {
  List<String> StickersList;
  void Function(String) addStickerToScreen;

  StickersGrid(
      {Key? key, required this.StickersList, required this.addStickerToScreen})
      : super(key: key);

  @override
  State<StickersGrid> createState() => _StickersGridState();
}

class _StickersGridState extends State<StickersGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      mainAxisSpacing: 5,
      //crossAxisSpacing: 10,
      children: List.generate(
        widget.StickersList.length,
        (index) => singleSticker(context, widget.StickersList[index]),
      ),
    );
  }

  Widget singleSticker(BuildContext context, imageNames) {
    return GestureDetector(
      onTap: () {
        widget.addStickerToScreen(imageNames);
        //return imageNames;
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Image(
          image: AssetImage(imageNames),
        ),
      ),
    );
  }
}
