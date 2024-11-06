//using geolocator
// import 'dart:convert';
//
// import 'package:favorite_place/models/place.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher_string.dart';
//
// class LocationInput extends StatefulWidget {
//   const LocationInput({super.key, required this.onSelectLocation});
//
//   final void Function(PlaceLocation placrlocation) onSelectLocation;
//
//   @override
//   State<LocationInput> createState() => _LocationInputState();
// }
//
// class _LocationInputState extends State<LocationInput> {
//   var _isGettingLocation = false;
//   String? _locationImage;
//   String locationMessage = "Current Location Of User";
//   late String lat;
//   late String lon;
//   PlaceLocation? _placeLocation;
//
//   Future<Position> _getLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error("Location Service are Disabled");
//     }
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error("Location Permission are denied");
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error("Location denied permanently");
//     }
//     return await Geolocator.getCurrentPosition();
//   }
//
//   void _liveLocation() {
//     LocationSettings locationSettings = const LocationSettings(
//         accuracy: LocationAccuracy.high, distanceFilter: 100);
//     Geolocator.getPositionStream(locationSettings: locationSettings)
//         .listen((Position position) {
//       lat = position.latitude.toString();
//       lon = position.longitude.toString();
//       setState(() {
//         locationMessage = "Latitude $lat Longitude $lon";
//         _locationImage =
//             'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=AIzaSyDfKjD3wI1CHfQPloj3sjFlPmptGSCYhh8';
//       });
//     });
//   }
//
//   Future<void> _openMap(String lat, String long) async {
//     String googleURL =
//         "https://www.google.com/maps/search/?api=1&query=$lat,$long";
//     await canLaunchUrlString(googleURL)
//         ? await launchUrlString(googleURL)
//         : throw "Could not launch $googleURL";
//   }
//
//   Future<String> _getAddress(double lat, double lon) async {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=AIzaSyDfKjD3wI1CHfQPloj3sjFlPmptGSCYhh8');
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['results'].isNotEmpty) {
//         return data['results'][0]['formatted_address'];
//       }
//     }
//     return "No address found";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget previewContent = Text(
//       "No Location Chosen",
//       textAlign: TextAlign.center,
//       style: Theme.of(context)
//           .textTheme
//           .bodyLarge!
//           .copyWith(color: Theme.of(context).colorScheme.onBackground),
//     );
//
//     if (_isGettingLocation) {
//       previewContent = const CircularProgressIndicator();
//     } else if (_locationImage != null) {
//       previewContent = Image.network(
//         _locationImage!,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: double.infinity,
//       );
//     }
//
//     return Column(
//       children: [
//         Container(
//             height: 170,
//             alignment: Alignment.center,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               border: Border.all(
//                   color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
//                   width: 1),
//             ),
//             child: previewContent),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             TextButton.icon(
//                 onPressed: () {
//                   setState(() {
//                     _isGettingLocation = true;
//                   });
//                   _getLocation().then((value) async {
//                     lat = "${value.latitude}";
//                     lon = "${value.longitude}";
//                     final address =
//                         await _getAddress(value.latitude, value.longitude);
//                     setState(() {
//                       locationMessage = "Latitude : $lat , Longitude : $lon";
//                       _locationImage =
//                           'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=AIzaSyDfKjD3wI1CHfQPloj3sjFlPmptGSCYhh8';
//                       _isGettingLocation = false;
//                       _placeLocation = PlaceLocation(
//                           latitude: lat, longitude: lon, address: address);
//                     });
//                     widget.onSelectLocation(_placeLocation!);
//                     _liveLocation();
//                   });
//                 },
//                 icon: const Icon(Icons.location_on),
//                 label: const Text("Get Current Location")),
//             TextButton.icon(
//                 onPressed: () {
//                   _openMap(lat, lon);
//                 },
//                 icon: const Icon(Icons.map),
//                 label: const Text("Select on map")),
//           ],
//         )
//       ],
//     );
//   }
// }
//using google map apis
/* import 'dart:convert';

import 'package:favorite_place/models/place.dart';
import 'package:favorite_place/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyDfKjD3wI1CHfQPloj3sjFlPmptGSCYhh8';
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyDfKjD3wI1CHfQPloj3sjFlPmptGSCYhh8');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    _savePlace(lat, lng);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );

    if (pickedLocation == null) {
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}*/
