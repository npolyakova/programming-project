import 'package:application_front/CORE/repositories/DataApplication.dart';
import 'package:application_front/CORE/repositories/NodeMap.dart';
import 'package:application_front/CORE/repositories/RoomData.dart';
import 'package:application_front/CORE/services/ApiClient.dart';
import 'package:application_front/CORE/services/Authentication.dart';
import 'package:dio/dio.dart';

class MapData
{
  static const String room_id = 'room_id', floor = 'floor', parent = 'parent', bounds = 'bounds', name = 'name';

  final ApiClient _apiClient = ApiClient(url: DataApplication.urlService);

  final Map<int, RoomData> rooms = {};

  final Map<int, NodeMap> navigationPoints = {};

  final Map<String, dynamic> testJson = 
  {
    "rooms": {
      "1": {
        "room_id": 1,
        "floor": 1,
        "parent": 0,
        "name": "Комната 1",
        "bounds": {
          "room_id": 1,
          "bounds": [
            {"x": 100, "y": 100},
            {"x": 150, "y": 150},
            {"x": 200, "y": 100},
            {"x": 180, "y": 80},
            {"x": 130, "y": 70}
          ]
        }
      },
      "2": {
        "room_id": 2,
        "floor": 1,
        "parent": 0,
        "name": "Комната 2",
        "bounds": {
          "room_id": 2,
          "bounds": [
            {"x": 250, "y": 100},
            {"x": 300, "y": 120},
            {"x": 350, "y": 100},
            {"x": 320, "y": 180},
            {"x": 280, "y": 150}
          ]
        }
      },
      "3": {
        "room_id": 3,
        "floor": 1,
        "parent": 0,
        "name": "Комната 3",
        "bounds": {
          "room_id": 3,
          "bounds": [
            {"x": 150, "y": 200},
            {"x": 200, "y": 220},
            {"x": 220, "y": 280},
            {"x": 180, "y": 300},
            {"x": 130, "y": 250},
            {"x": 140, "y": 220}
          ]
        }
      }
    }
  };

  Future<void> GetRoomData() async
  {
    // if(Authentication.CurrentUser == null)
    // {
    //   throw Exception('Вы не авторизованы');
    // }
    var answer;
    try
    {
      answer = await _apiClient.Get('/rooms', Authentication.CurrentUser!);
    }
    catch(e)
    {
      //Debug
      answer = Response(data: testJson, requestOptions: RequestOptions()); 
    }
    for(var room in answer.data['rooms'].entries)
    {
      rooms[room.value[room_id]] = RoomData(id: room.value[room_id], floor: room.value[floor], parent: room.value[parent], name: room.value[name],
       bounds: RoomBounds.ToJson(room.value[bounds]));
    }
  } 

}