import 'dart:math';

import 'package:flutter/material.dart';

class Vector2
{
  final double x;
  final double y;

  Vector2({required this.x, required this.y});

  factory Vector2.ToJson(Map<String, dynamic> json)
  {
    return Vector2(
      x: (json['x'] ?? 0).toDouble(),
      y: (json['y'] ?? 0).toDouble());
  }
}

class RoomBounds {
  final int id;
  final List<Vector2> bounds;
  
  RoomBounds({
    required this.id,
    required this.bounds,
  });

  factory RoomBounds.ToJson(Map<String, dynamic> json) {
    return RoomBounds(
      id: json['room_id'],
      bounds: (json['bounds'] as List<dynamic>?)
            ?.map((e) => Vector2.ToJson(e as Map<String, dynamic>))
            .toList() ?? []
    );
  }
}

class RoomData 
{
  final int id;
  final int floor;
  final int parent;
  final String name;
  
  final RoomBounds bounds;

  RoomData({required this.id, required this.floor, required this.parent, required this.name, required this.bounds});

  factory RoomData.ToJson(Map<String, dynamic> json)
  {
    return RoomData(
      id: json['room_id'] ?? -1,
      floor: json['floor'] ?? -1,
      parent: json['parent'] ?? -1,
      name: json['name'] ?? 'none',
      bounds: RoomBounds.ToJson(json['bounds'])
    );
    
  }

  bool isClickInside(double x, double y) {
    Rect boundingBox = getBoundingBox();
    double mapX = x + boundingBox.left;
    double mapY = y + boundingBox.top;
    return _PointInPolygonChecker.isPointInPolygon(bounds.bounds, mapX, mapY);
  }

  Rect getBoundingBox() {
    if (bounds.bounds.isEmpty) return Rect.zero;
    
    // Находим крайние точки комнаты
    double minX = bounds.bounds[0].x;
    double minY = bounds.bounds[0].y;
    double maxX = bounds.bounds[0].x;
    double maxY = bounds.bounds[0].y;

    // Проходим по всем точкам, ищем минимальные и максимальные координаты
    for (var point in bounds.bounds) {
      if (point.x < minX) minX = point.x;
      if (point.y < minY) minY = point.y;
      if (point.x > maxX) maxX = point.x;
      if (point.y > maxY) maxY = point.y;
    }

    // Возвращаем прямоугольник, который охватывает всю комнату
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  Widget GetRoomButton(Function(String name, int id) OnTap)
  {
      return _ClickableRoomBounds(data: this, onTap: OnTap);
  }
}


class _ClickableRoomBounds extends StatelessWidget {
  final RoomData data;
  final Function(String name, int id) onTap;

  _ClickableRoomBounds({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Находим размеры области
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (var point in data.bounds.bounds) {
      minX = min(minX, point.x);
      minY = min(minY, point.y);
      maxX = max(maxX, point.x);
      maxY = max(maxY, point.y);
    }

    return Positioned(
      left: minX,
      top: minY,
      width: maxX - minX,
      height: maxY - minY,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
         onTapDown: (details) {
        if (data.isClickInside(details.localPosition.dx, details.localPosition.dy)) {
            onTap(data.name, data.id);
          }
        },
        child: CustomPaint(
          painter: _RoomPainter(bounds: data.bounds, offset: Offset(-minX, -minY)),
        ),
      ),
    );
  }
}

class _PointInPolygonChecker {
  /// Проверяет, находится ли точка внутри полигона
   static bool isPointInPolygon(List<Vector2> polygon, double px, double py) {
    if (polygon.length < 3) return false;
    
    bool collision = false;
    
    // Проходим по всем сторонам многоугольника
    for (int current = 0; current < polygon.length; current++) {
      int next = (current + 1) % polygon.length;
      
      Vector2 vc = polygon[current]; // Текущая вершина
      Vector2 vn = polygon[next];    // Следующая вершина
      
      // Проверяем, пересекает ли луч эту сторону
      if (((vc.y > py && vn.y < py) || (vc.y < py && vn.y > py)) &&
          (px < (vn.x - vc.x) * (py - vc.y) / (vn.y - vc.y) + vc.x)) {
            collision = !collision;
      }
    }
    
    return collision;
  }

  // Добавим метод для отладки
  static void debugPrint(List<Vector2> polygon, double px, double py) {
    print('Checking point ($px, $py)');
    for (var point in polygon) {
      print('Polygon point: (${point.x}, ${point.y})');
    }
    print('Result: ${isPointInPolygon(polygon, px, py)}');
  }
}

class _RoomPainter extends CustomPainter {
  final RoomBounds bounds;
  final Offset offset; // Смещение для корректного отображения

  _RoomPainter({required this.bounds, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint() // Добавляем обводку для наглядности
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    
    // Применяем смещение к координатам
    path.moveTo(bounds.bounds[0].x + offset.dx, bounds.bounds[0].y + offset.dy);
    
    for(int i = 1; i < bounds.bounds.length; i++) {
      path.lineTo(bounds.bounds[i].x + offset.dx, bounds.bounds[i].y + offset.dy);
    }
    
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool hitTest(Offset position) {
    final path = Path();
    path.moveTo(bounds.bounds[0].x + offset.dx, bounds.bounds[0].y + offset.dy);
    for(int i = 1; i < bounds.bounds.length; i++) {
      path.lineTo(bounds.bounds[i].x + offset.dx, bounds.bounds[i].y + offset.dy);
    }
    path.close();
    return path.contains(position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}