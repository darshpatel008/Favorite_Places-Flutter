import 'package:favorite_place/model/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen
      (
       { super.key,
         this.location = const PlaceLocation
           (
             longitude: 37.42,
             latitude: -122.084,
             address: '',
           ),
         this.isSelecting = true,
        }
      );

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  LatLng? _pickedlocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting? 'Pick Your Location' : 'Your Location'),
        actions: [
          if(widget.isSelecting)
            IconButton(
                onPressed: (){
                    Navigator.of(context).pop(_pickedlocation);
                },
                icon: Icon(Icons.save))
        ],
      ),
      body: GoogleMap(
        onTap: widget.isSelecting ==false
            ? null
            : (position){
          setState(() {
           _pickedlocation = position;
          });
        },
        initialCameraPosition: CameraPosition
          (
            target: LatLng //initial location
              (
                widget.location.latitude,   //by default
                widget.location.longitude    //by default
              ),
          zoom: 16,
          ),
                markers: (_pickedlocation == null && widget.isSelecting) ? {} :
            {
                Marker //user may peak location
              (
                markerId: MarkerId('m1'),
                position:  _pickedlocation!= null ? _pickedlocation! :LatLng
                 (
                    widget.location.latitude,
                     widget.location.longitude
                 ),
               )
            }
      ),

    );
  }
}
