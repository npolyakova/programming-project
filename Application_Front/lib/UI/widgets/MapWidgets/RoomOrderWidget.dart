import 'package:application_front/CORE/repositories/MapData.dart';
import 'package:application_front/CORE/repositories/RoomData.dart';
import 'package:flutter/material.dart';

class RoomOrderPaiting extends StatefulWidget 
{

  static final GlobalKey<_RoomOrderState> globalKey = GlobalKey<_RoomOrderState>();

  const RoomOrderPaiting({
    super.key,
  });
  
  @override
  State<RoomOrderPaiting> createState() => _RoomOrderState();
}

class _RoomOrderState extends State<RoomOrderPaiting> 
{
  RoomBounds? bounds;
  Offset? offset;
  bool isPressed = false;

  void updateRoom(bool newIsPressed, RoomBounds? newBounds, Offset? newOffset) {
    setState(() {
      isPressed = newIsPressed;
      bounds = newBounds;
      offset = newOffset;
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    if(!isPressed || bounds == null || offset == null)
    {
      return const SizedBox.shrink();
    }
   return CustomPaint(painter:  PressedRoomPainter(bounds: bounds!, offset: offset!));
  }
}

