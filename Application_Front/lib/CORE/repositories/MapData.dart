import 'package:application_front/CORE/repositories/DataApplication.dart';
import 'package:application_front/CORE/repositories/NodeMap.dart';
import 'package:application_front/CORE/repositories/PathOfID.dart';
import 'package:application_front/CORE/repositories/RoomData.dart';
import 'package:application_front/CORE/services/ApiClient.dart';
import 'package:application_front/CORE/services/Authentication.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MapData
{
  static const String room_id = 'id', floor = 'floor', parent = 'parent', bounds = 'bounds', name = 'name';

  final ApiClient _apiClient = ApiClient(url: DataApplication.urlService);

  final Map<int, RoomData> rooms = {};

  final Map<int, NodeMap> navigationPoints = {};

  PathOfID pathID = PathOfID();

  final Map<String, dynamic> testJson = 
  {
    "rooms": [
      {
        "id": 1,
        "floor": 1,
        "parent": 0,
        "name": "Комната 1",
        "bounds": [
            {"x": 344, "y": 91},
            {"x": 428, "y": 91},
            {"x": 428, "y": 150},
            {"x": 344, "y": 150},
          ]
      },
     
    ]
  };

  Future<void> GetRoomData() async
  {
    if(Authentication.CurrentUser == null)
    {
      throw Exception('Вы не авторизованы');
    }
    try
    {
        final response = await _apiClient.Get('/rooms', Authentication.CurrentUser!);

        if (response.data == null) 
        {
          throw Exception('Пустой ответ от сервера');
        }
        
        final roomsList =  response.data['rooms'] as List<dynamic>; //testJson['rooms'] as List<dynamic>;
        for(var room in roomsList) 
        {
            int id = room['id'];
            rooms[id] = RoomData(
                id: id, 
                floor: room['floor'], 
                parent: room['parent'] ?? -1, 
                name: room['name'],
                bounds: RoomBounds.Create(id, room['bounds']
                )
            );
        }
    }
    catch(e)
    {
      print('Ошибка при загрузке комнат: $e');
      throw Exception('Не удалось загрузить комнаты: $e');
    }
  } 

  List<Offset> GetPathOffset()
  {
    List<Offset> pathBuild = [];
    for(int i = 0; i < pathID.path.length; i++)
    {
      if(navigationPoints.length < 1)
        return pathBuild;
      NodeMap curNode = navigationPoints[i]!;
      pathBuild.add(Offset(curNode.x, curNode.y));
    }
    return pathBuild;
  }

}