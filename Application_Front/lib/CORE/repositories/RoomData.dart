
class Vector2
{
  final int x;
  final int y;

  Vector2({required this.x, required this.y});

  factory Vector2.ToJson(Map<String, dynamic> json)
  {
    return Vector2(
      x: json['x'] ?? 0,
      y: json['y'] ?? 0);
  }
}

class RoomBounds {
  final int id;
  final List<Vector2> bounds;
  
  RoomBounds({
    required this.id,
    required this.bounds,
  });

  factory RoomBounds.ToJson(Map<String, dynamic> json)
  {
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

  RoomData({required this.id, required this.floor, required this.parent, required this.name});

  factory RoomData.ToJson(Map<String, dynamic> json)
  {
    return RoomData(
      id: json['room_id'],
      floor: json['floor'],
      parent: json['parent'],
      name: json['name'],
    );
  }

}