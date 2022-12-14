import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class SingleFrame extends StatelessWidget {
  String imageNames;
  SingleFrame({Key? key, required this.imageNames}) : super(key: key);
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Photo Frame"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 80,
          child: Stack(
            children: [
              Positioned(
                child: MatrixGestureDetector(
                  onMatrixUpdate: (m, tm, sm, rm) {
                    notifier.value = m;
                  },
                  child: AnimatedBuilder(
                    animation: notifier,
                    builder: (context, child) {
                      return Transform(
                        transform: notifier.value,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.white30,
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/arbad.jpg"),
                                )),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              IgnorePointer(
                child: Container(
                  // width: double.infinity,
                  // height: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: AssetImage(imageNames))),
                  //child: Image.asset(imageNames,fit: BoxFit.cover,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
