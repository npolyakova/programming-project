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
      NodeMap(X: 10, Y: 10, Name: '1', Description: ''),
      NodeMap(X: 30, Y: 10, Name: '2', Description: ''),
      NodeMap(X: 50, Y: 10, Name: '3', Description: ''),
      NodeMap(X: 70, Y: 10, Name: '4', Description: ''),
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