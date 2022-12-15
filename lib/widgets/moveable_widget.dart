import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class MoveableWidget extends StatelessWidget {

  Widget item;
  MoveableWidget({Key? key,required this.item}) : super(key: key);
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(
      onMatrixUpdate: (m, tm, sm, rm) {
        notifier.value = m;
      },
      child: AnimatedBuilder(
        animation: notifier,
        builder: (context, child) {
          return Transform(
            transform: notifier.value,
            child: FittedBox(
              fit: BoxFit.contain,
              child: item,
            )
          );
        },
      ),
    );
  }
}
