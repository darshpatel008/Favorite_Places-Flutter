import 'package:favorite_place/main.dart';
import 'package:favorite_place/model/place.dart';
import 'package:favorite_place/screens/map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

  PlaceLocation? pickedLocation; //we created PlaceLocation type is location which is needed and its in model folder
  var isGettingLocation = false; //we created

  String get locationImage {
    if (pickedLocation == null) {
      return '';
    }

    final lat = pickedLocation!.latitude;
    final lng = pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$lat,$lng&key=AIzaSyDfKjD3wI1CHfQPloj3sjFlPmptGSCYhh8';
  }

  void getCurrentLocation() async //this code is copied form a  location package
      {
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

    setState(() { //we created
      isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude; //we created
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

  _saveplace(lat, lng);

  }




  Future<void> _saveplace(double latitude , double longitude) async

  {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyDfKjD3wI1CHfQPloj3sjFlPmptGSCYhh8');
    final response = await http.get(url); //must add as http in import

    final resdata = jsonDecode(response.body);

    final address = resdata['results'][0]['formatted_address'];

    setState(() { //we created
      pickedLocation = PlaceLocation(
          longitude: latitude,
          latitude: longitude,
          address: address); //sending data to PlaceLocation are created in model folder
      isGettingLocation = false;
    });

    widget.onSelectLocation(pickedLocation!);
  }


  void _selectOnMap() async
  {
    final pickedlocation = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(builder: (ctx) => MapScreen()
        ),
      );

    if(pickedlocation == null)
      {
        return;
      }
    _saveplace(pickedlocation.latitude, pickedlocation.longitude);
  }


  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text('No Location Chosen',
      textAlign: TextAlign.center,
      style: Theme
          .of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: colorScheme.onSurface),
    );

    if (pickedLocation != null) {
      previewContent = Image.network(
          locationImage,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity);
    }

    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }


    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.2))),
            child: previewContent
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
                onPressed: getCurrentLocation,
                label: Text('Get current Location'),
                icon: Icon(Icons.location_on)
            ),
            TextButton.icon(
                onPressed: _selectOnMap,
                label: Text('Select on Map'),
                icon: Icon(Icons.map)
            )
          ],
        )
      ],
    );
  }
}
