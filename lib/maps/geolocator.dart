import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  final Geolocator geo = Geolocator();

  Stream<Position> getCurrentLocation() {
    var locationOptions = LocationOptions(
        accuracy: LocationAccuracy.high, distanceFilter: 10);
    return geo.getPositionStream(locationOptions);
  }

  Future<Position> getInitialLocation() async {
    return geo.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
//   var _distanceInMeters = await geo().distanceBetween(
//   _latitudeForCalculation,
//   _longitudeForCalculation,
//   _currentPosition.latitude,
//   _currentPosition.longitude,
//   );
}