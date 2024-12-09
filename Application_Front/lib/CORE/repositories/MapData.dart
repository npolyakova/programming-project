import 'package:application_front/CORE/repositories/DataApplication.dart';
import 'package:application_front/CORE/repositories/NodeMap.dart';
import 'package:application_front/CORE/repositories/RoomData.dart';
import 'package:application_front/CORE/repositories/User.dart';
import 'package:application_front/CORE/services/ApiClient.dart';
import 'package:application_front/CORE/services/Authentication.dart';

class MapData
{
  static const String room_id = 'room_id', floor = 'floor', parent = 'parent', bounds = 'bounds', name = 'name';

  final ApiClient _apiClient = ApiClient(url: DataApplication.urlService);

  final Map<int, RoomData> rooms = {};

  final Map<int, NodeMap> navigationPoints = {};

  Future<void> GetRoomData() async
  {
    if(Authentication.CurrentUser == null)
    {
      throw Exception('Вы не авторизованы');
    }
    var answer = await _apiClient.Get('/rooms', Authentication.CurrentUser!);
    for(var room in answer.data['rooms'].entries)
    {
      rooms[room[room_id]] = RoomData(id: room[room_id], floor: room[floor], parent: room[parent], name: room[name], bounds: room[bounds]);
    }
  } 

}