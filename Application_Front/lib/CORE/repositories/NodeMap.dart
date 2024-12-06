import 'package:flutter/material.dart';

class NodeMap extends StatelessWidget
{
  final double X,Y;

  final String Name, Description;

  const NodeMap({super.key, required this.X, required this.Y, required this.Name, required this.Description});
  @override
  Widget build(BuildContext context) 
  {
    return Positioned(
      right: X,
      top: Y,
      child: _GetPoint(),
    );
  }

  Widget _GetPoint()
  {
    return Container(width: 10, height: 10,color: Colors.red,);
  }

}