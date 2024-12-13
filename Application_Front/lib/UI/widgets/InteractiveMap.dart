import 'dart:async';
import 'package:application_front/CORE/repositories/MapCoordinateTransformer.dart';
import 'package:application_front/CORE/repositories/NodeMap.dart';
import 'package:flutter/material.dart';
import 'package:application_front/CORE/repositories/MapData.dart';

class InteractiveMap extends StatefulWidget
{
  final Function(String, int) onRoomTap;

  const InteractiveMap({super.key, required this.onRoomTap});
  @override
  State<StatefulWidget> createState() 
  {
    return _InteractiveMap();
  }
  
}

class _InteractiveMap extends State<InteractiveMap>
  {
  late final Image _mapImage;

  late final List<NodeMap> nodes;

  late final MapData _mapData;

  bool _isDataLoaded = false;

  late final Function(String, int) OnTap;

  MapCoordinateTransformer? _coordinator;

  @override
  void initState()
  {
     _mapData = MapData();
     _mapImage = Image.asset('Resources/MainMapTest.jpg');

     late Size? _imageSize;
   
     nodes = 
     [
      NodeMap(x: 10, y: 10, id: 1),
      NodeMap(x: 30, y: 10, id: 2),
      NodeMap(x: 50, y: 10, id: 3),
      NodeMap(x: 70, y: 10, id: 4),
     ];
    super.initState();
  }
  Future<void> _initializeData() async {
  if(_isDataLoaded)
    return;
  try {
    await _mapData.GetRoomData();
    setState(() {_isDataLoaded = true;});
  } catch (e) {
    print('Ошибка при инициализации данных: $e');
  }
}
  @override
 Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
        }

        return Container(
          child: InteractiveViewer(
            transformationController: _coordinator?.transformationController,
            boundaryMargin: EdgeInsets.all(20),
            scaleFactor: 1.5,
            minScale: 0.5,
            maxScale: 100,
            child: Stack(
              children: [
                Align(alignment: AlignmentDirectional.topStart, child: _mapImage),
                ...nodes,
                ..._mapData.rooms.values.map((room) => 
                  room.GetRoomButton(widget.onRoomTap)
                ).toList(),
              ],
            ),
          )
        );
      }
    );
  }

}
  