import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  List coordinates;
  String currentLocation;
bool isBottomNav=false;
  GoogleMapScreen({required this.coordinates,required this.isBottomNav, required this.currentLocation, Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}
class _GoogleMapScreenState extends State<GoogleMapScreen> {
  @override
  void initState() {
    currentmarker();
    // TODO: implement initState
    super.initState();
  }
  
  Set<Marker> markersList = {};
  currentmarker() {
    markersList.clear(); // Clear existing markers
    markersList.add(Marker(
      markerId: const MarkerId("0"),
      position:LatLng(widget.coordinates[0],widget.coordinates[1]),
      infoWindow:  InfoWindow(title: widget.currentLocation),

    ));
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Map Sceen coordinates: ${widget.coordinates[0]}, ${widget.coordinates[1]}");
    }
    return Scaffold(
      appBar:widget.isBottomNav==false? AppBar(title: const Text("Map"),):null,
      body: Stack(
        children: [
          // GoogleMap widget to display the map
          ClipRRect(borderRadius: BorderRadius.circular(15),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(widget.coordinates[0],widget.coordinates[1]),
                  zoom: 16,
                  ),
                  mapType: MapType.normal,
              markers: markersList,
              onMapCreated: (GoogleMapController controller) {},
            ),
          ),
        ],
      ),
    );
  }
}
