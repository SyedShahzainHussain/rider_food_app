import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Placemark>? placemarks;
Position? position;
String? address;
SharedPreferences? sharedPreferences;
String? perPlaceDeliveryAmount;
String? previousEarning; // ! previous earnings of sellers
String? previousRiderEarning; // ! previous earnings of rider

Future<void> getCurrentLocation() async {
  await Geolocator.requestPermission();
  Position positioned = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  position = positioned;
  placemarks =
      await placemarkFromCoordinates(positioned.latitude, positioned.longitude);
  Placemark placemark = placemarks![0];

  String fullAddress =
      "${placemark.subThoroughfare} ${placemark.thoroughfare} ${placemark.subAdministrativeArea} ${placemark.administrativeArea} ${placemark.locality} ${placemark.subLocality}";
  address = fullAddress;
}
