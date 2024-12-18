import 'dart:ui';

import 'package:application_front/CORE/repositories/MapData.dart';
import 'package:application_front/CORE/repositories/RoomData.dart';
import 'package:flutter/material.dart';

class PathContainer extends StatelessWidget {

  const PathContainer();

  @override
  Widget build(BuildContext context) {
    return PathContainer();
  }
}

class PathPaiting extends StatefulWidget {

  const PathPaiting();

  @override
  State<PathPaiting> createState() => _PathContentState();
}

class _PathContentState extends State<PathPaiting> {

  

  late final MapData _mapData;
  late final Image _mapImage;
  bool _isDataLoaded = false;
  

  @override
  Widget build(BuildContext context) {
   return CustomPaint(painter:  _PathPainter(poits: _mapData));
  }
}

class _PathPainter extends CustomPainter {
  final MapData poits;

  _PathPainter({
    required this.poits});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final strokePaint = Paint() // Добавляем обводку для наглядности
      ..color = const Color.fromARGB(255, 48, 235, 31)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPoints(PointMode.lines, poits.GetPathOffset(), paint);
    
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) => 
      true; 
}