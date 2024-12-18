import 'dart:ui';

import 'package:application_front/CORE/repositories/MapData.dart';
import 'package:application_front/CORE/repositories/RoomData.dart';
import 'package:flutter/material.dart';


class PathPaiting extends StatefulWidget {

  final int startPoint;
  final int endPoint;

  final MapData mapData;

  const PathPaiting({
    required this.startPoint,
    required this.endPoint,
    required this.mapData
  });
  
  
  @override
  State<PathPaiting> createState() => _PathContentState();
}

class _PathContentState extends State<PathPaiting> {
  
  bool _isDataLoaded = false;

  List<Vector2> route = [];
  
  @override
  void initState() {
    super.initState();
    _loadPathData();
  }

  Future<void> _loadPathData() async {
    setState(() => _isDataLoaded = false);
    
    try {

      final pathJson = await widget.mapData.getPathData(
        widget.startPoint, 
        widget.endPoint
      );
      
      route = parseRouteFromJson(pathJson);
      // Обновляем _mapData с новым маршрутом
      setState(() {
        _isDataLoaded = true;
      });
    } catch (e) 
    {
      print('---------> Ошибка загрузки пути: $e');
      setState(() => _isDataLoaded = true);
    }
  }

  List<Vector2> parseRouteFromJson(List<dynamic> jsonRoute) {
    return jsonRoute.map((pointStr) {
      // Убираем фигурные скобки и разделяем по запятой
      String cleanStr = pointStr.toString()
          .replaceAll('{', '')
          .replaceAll('}', '');
      
      List<String> coordinates = cleanStr.split(',');
      
      return Vector2(
        x: double.parse(coordinates[0].trim()),
        y: double.parse(coordinates[1].trim())
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) 
  {
    if (_isDataLoaded == false || route.length < 1)
    {
      return const Center(child: CircularProgressIndicator());
    }
   return CustomPaint(painter:  _PathPainter(path: route));
  }
}

class _PathPainter extends CustomPainter {

  final List<Vector2> path;

  _PathPainter({
    required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final strokePaint = Paint() // Добавляем обводку для наглядности
      ..color = const Color.fromARGB(255, 48, 235, 31)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPoints(PointMode.lines, GetPathOffset(), paint);
    
  }

  List<Offset> GetPathOffset()
  {
    List<Offset> pathBuild = [];
    for(int i = 0; i < path.length; i++)
    {
      if(path.length < 1)
        return pathBuild;
      Vector2 curPoint = path[i]!;
      pathBuild.add(Offset(curPoint.x, curPoint.y));
    }
    return pathBuild;
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) => 
      true; 
}