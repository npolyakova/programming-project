import 'dart:async';
import 'package:application_front/CORE/repositories/MapCoordinateTransformer.dart';
import 'package:application_front/CORE/repositories/NodeMap.dart';
import 'package:application_front/CORE/repositories/RoomData.dart';
import 'package:flutter/material.dart';
import 'package:application_front/CORE/repositories/MapData.dart';

class InteractiveMap extends StatefulWidget
{
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

  late final MapCoordinateTransformer _coordinator;

  @override
  void initState()
  {
     _mapData = MapData();
     _mapImage = Image.asset('Resources/MainMapTest.jpg');

     late Size? _imageSize;
   
    // Получаем размер из уже загруженного Image
    WidgetsBinding.instance.addPostFrameCallback((_) {
     _mapImage.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo info, bool _) 
        {
          if (mounted) 
          {  // Проверяем, что виджет всё ещё существует
            setState(() 
            {
              _imageSize = Size(
                info.image.width.toDouble(),
                info.image.height.toDouble());
              _coordinator = MapCoordinateTransformer(transformationController: TransformationController(), imageSize:  _imageSize!);
              print('Image size loaded: ${_imageSize?.width} x ${_imageSize?.height}');
            });
          }
        })
      );
     });
     nodes = 
     [
      NodeMap(x: 10, y: 10, id: 1),
      NodeMap(x: 30, y: 10, id: 2),
      NodeMap(x: 50, y: 10, id: 3),
      NodeMap(x: 70, y: 10, id: 4),
     ];
    _initializeData();
    super.initState();
  }
  Future<void> _initializeData() async {
  try {
    await _mapData.GetRoomData();
    if (mounted) { 
      setState(() {});
    }
  } catch (e) {
    print('Ошибка при инициализации данных: $e');
  }
}
  @override
  Widget build(BuildContext context) 
  {
      return Container(
        child:  InteractiveViewer(
        boundaryMargin: EdgeInsets.all(20),
        scaleFactor: 1.5,
        minScale: 0.5,
        maxScale: 10,
        child: Stack(
          children: 
          [
            Align(alignment:  AlignmentDirectional.topStart, child: _mapImage),
            ...nodes,
             ..._mapData.rooms.values.map((room) => 
              room.GetRoomButton((name, id) => print("${name} is tap"))
            ).toList(),
          ],
        ) ,
      )
      );
  }

  }
  