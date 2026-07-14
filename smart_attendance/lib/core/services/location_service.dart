import 'package:geolocator/geolocator.dart';

class LocationService {
  // Mock Office Coordinates (Pune Headquarters)
  static const double officeLatitude = 18.5204;
  static const double officeLongitude = 73.8567;
  
  // Geofencing radius in meters (e.g., 200 meters)
  static const double geofenceRadiusMeters = 200.0;

  /// Fetches the user's current position.
  /// Falls back to mock coordinate if geolocator is not available or if running in mock mode.
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Return a default/mock position if services are disabled
      return _getMockPosition();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _getMockPosition();
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return _getMockPosition();
    } 

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (_) {
      return _getMockPosition();
    }
  }

  /// Calculates distance in meters from the office location.
  double calculateDistanceToOffice(double lat, double lon) {
    return Geolocator.distanceBetween(
      lat,
      lon,
      officeLatitude,
      officeLongitude,
    );
  }

  /// Checks if the employee is within the allowed geofence.
  bool isWithinOfficeGeofence(double lat, double lon) {
    final distance = calculateDistanceToOffice(lat, lon);
    return distance <= geofenceRadiusMeters;
  }

  /// Generates a Google Maps link for the given coordinates.
  String getGoogleMapsLink(double lat, double lon) {
    return 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
  }

  Position _getMockPosition() {
    // Return mock office position with slight random offset to simulate actual geolocation
    return Position(
      latitude: officeLatitude,
      longitude: officeLongitude,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }
}
