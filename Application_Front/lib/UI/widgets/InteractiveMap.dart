import 'package:application_front/CORE/repositories/NodeMap.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
     _mapImage = Image.asset('Resources/MainMapTest.jpg');
     nodes = 
     [
      NodeMap(x: 10, y: 10, id: 1),
      NodeMap(x: 30, y: 10, id: 2),
      NodeMap(x: 50, y: 10, id: 3),
      NodeMap(x: 70, y: 10, id: 4),
     ];
    super.initState();
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
            Align(alignment:  AlignmentDirectional.topStart,child: _mapImage),
            ...nodes
          ],
        ) ,
      )
      );
  }

  }