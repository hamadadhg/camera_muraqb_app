import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

double translateX(
  double x,
  //x position in horizontal divider in image(because the user can put face it nearby to right or left)
  Size canvasSize,
  //to determined to display flutter screen or camera screen
  Size imageSize, //actual camera image size
  InputImageRotation rotation, //rotation the image from MLKit
  CameraLensDirection cameraLensDirection,
  //to determined if you want use front camera or back camera
) {
  //this method to calculate width(horizontal divider(x line)), because when the user appear camera to check from face it will appear red square
  //i need to calculate because size camera screen different on size flutter screen sometimes
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return x *
          canvasSize.width /
          (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation270deg:
      return canvasSize.width -
          x *
              canvasSize.width /
              (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      switch (cameraLensDirection) {
        case CameraLensDirection.back:
          return x * canvasSize.width / imageSize.width;
        default:
          return canvasSize.width - x * canvasSize.width / imageSize.width;
      }
  }
  //so this operations to deal if the user uses the camera and rotate device it to right, left, bottom, or leave it to top
  //Platform to check from type device the user if type the mobile is ios or anything else(android,..)
}

double translateY(
  double y,
  //y position in vertical divider in image(because the user can put face it nearby to top or bottom)
  Size canvasSize,
  //to determined to display flutter screen or camera screen
  Size imageSize, //actual camera image size
  InputImageRotation rotation, //rotation the image from MLKit
  CameraLensDirection cameraLensDirection,
  //to determined if you want use front camera or back camera
) {
  //this method to calculate height(vertical divider(y line)), because when the user appear camera to check from face it will appear red square
  //i need to calculate because size camera screen different on size flutter screen sometimes
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y *
          canvasSize.height /
          (Platform.isIOS ? imageSize.height : imageSize.width);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      return y * canvasSize.height / imageSize.height;
  }
  //so this operations to deal if the user uses the camera and rotate device it to right, left, bottom, or leave it to top
  //Platform to check from type device the user if type the mobile is ios or anything else(android,..)
}

class FaceDetectorPainter extends CustomPainter {
  //FaceDetectorPainter: Draw rectangle around detected face in camera, and Displays a label name in the left top corner in the rectangle
  //CustomPainter: enable you to draw on screen like rectangles, lines, text,..
  final List<Face> faces;
  //list of faces and all face contain on rectangle
  final Size imageSize; //actual camera image size
  final InputImageRotation rotation; //rotation the image from MLKit
  final CameraLensDirection cameraLensDirection;
  //to determined if you want use front camera or back camera
  final String name;
//lable name for user and will appear next to top left the rectangle
  FaceDetectorPainter(
    this.faces,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
    this.name,
  );

  @override
  void paint(Canvas canvas, Size size) {
    //This method draws everything into the screen, and this method receive
    //canvas: to determined to display flutter screen or camera screen
    //size: the size of the screen area you're drawing on it(like phone screen or widget size)
    final Paint paint1 = Paint() //draw on screen
      ..style = PaintingStyle.stroke //draw rectangle
      ..strokeWidth = 2.0 //thickness the width for rectangle is 2
      ..color = Colors.red; //color the rectangle is red

    for (final Face face in faces) {
      //in this loop when the cmera detect face so this loop will work
      final left = translateX(
        face.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      ); //draw left side in the rectangle,and sure left is horizontal(x)
      final top = translateY(
        face.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      ); //draw top side in the rectangle,and sure top is vertical(y)
      final right = translateX(
        face.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      ); //draw right side in the rectangle,and sure right is horizontal(x)
      final bottom = translateY(
        face.boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      ); //draw bottom side in the rectangle,and sure bottom is vertical(y)
      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint1,
      );
      //so i have values all parameters(left, top, right, bottom), and i tell it in screen(canvas) i want draw rectangle(.drawRect)
      //so give the drawRect method(sides, and styles the border that will paint it)
      ui.ParagraphBuilder pb = ui.ParagraphBuilder(
        //first ui parameter i can use it from(import 'dart:ui' as ui;)
        //ParagraphBuilder to give it style to labelText, that it's next to the rectangle
        ui.ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      );
      pb.pushStyle(
        ui.TextStyle(color: Colors.red),
      ); //make text color in label is red
      pb.addText(name); //add this label text
      pb.pop();
//finish the operation(because when you use pushStyle you must use pop, because sometimes happen problems for Example: you want this lable(Hamada) the color it is green and this lable(Jannat) the color it is red so when you don't use pop you don't tell it operation first label i finished from it now will work on new operation)
      final paragraph = pb.build();
      //.build: like tell so start draw the rectangle, and label text
      paragraph.layout(ui.ParagraphConstraints(width: face.boundingBox.width));
      //when you start draw, so you should ensure(the rectangle cover the face(no take big height or width) and the label text doesn't take big width), so you should know how there is width in paragraph is allowed to draw
      final textOffset = Offset(right, top - paragraph.height - 8);
      //i determined position the text(in top right and from top i tell move to bottom but little move(8))
      canvas.drawParagraph(paragraph, textOffset);
      //finish orders now start draw the rectangle and label text
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
    //this method to tell CustomPainter if you know this face and size this image i mean you draw it previous so return false because Nothing changed you're looking at the same faces and image, so no need to repaint, if return true Something changed(like faces or image size), so you should repaint
  }
}
