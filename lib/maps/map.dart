import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MapBody extends StatefulWidget {
  final Position initialPosition;

  MapBody(this.initialPosition);

  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<MapBody> {

  @override
  Widget build(BuildContext context) {
  }

}


