import 'package:geolocator/geolocator.dart';

class GeolocationService {
  // Check permissions and listen to live location updates
  Stream<Position> getPositionStream() async* {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      yield* Stream.error('Location services are disabled.');
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        yield* Stream.error('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      yield* Stream.error('Location permissions are denied forever.');
      return;
    }

    // Return the position stream which continuously updates as the location changes
    yield* Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Adjust the distance filter to get updates when moving by 10 meters
      ),
    );
  }
}
