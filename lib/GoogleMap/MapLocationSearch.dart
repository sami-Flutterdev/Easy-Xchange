
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/GoogleMap/mapSearchScreen.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/viewModel/userViewModel.dart';

import 'package:nb_utils/nb_utils.dart';

import 'package:provider/provider.dart';



class MapLocationSearch extends StatefulWidget {
  const MapLocationSearch({Key? key}) : super(key: key);

  @override
  State<MapLocationSearch> createState() => _MapLocationSearchState();
}

class _MapLocationSearchState extends State<MapLocationSearch> {
  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(34.025917, 71.560135),
      zoom: 14);
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};
  double initialLat = 0.0;
  double initialLng = 0.0;
  bool isLoading = false;
  
    getCurrentLocation() async {
    var locations= await Geolocator.getCurrentPosition();
       initialLat = locations.latitude;
    initialLng = locations.longitude;
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(initialLat, initialLng),
        zoom: 16)));
    List<Placemark> placemarks = await placemarkFromCoordinates(initialLat, initialLng);
    _searchController.text = "${placemarks.last.locality.toString()} ${placemarks.last.administrativeArea.toString()}";

    setState(() {
      _markers.add(Marker(
          markerId: const MarkerId("1"),
          position: LatLng(locations.latitude, locations.longitude),
          infoWindow: const InfoWindow(title: "My Position")));
    });
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }


 @override
  void initState() {
   var userViewModel =Provider.of<UserViewModel>(context,listen: false);
    // TODO: implement initState
    super.initState();
   userViewModel.getCurrentLocationPermission();
      //onChange();   
  }
   var newVar;
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(initialLat);
      print("rebuild");
    print("HIHI");
    }
    
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){finish(context);},
          child: const Icon(Icons.arrow_back,color:AppColors. whiteColor)),
        backgroundColor:AppColors. primaryColor,
        title: GestureDetector(
          onTap: ()async{
          _searchController.text =await  showSearch(context: context, delegate: MapSearchScreen());
          if (kDebugMode) {
            print(newVar);
          }
           searchLocation();
           setState(() {
              
           });
                      
          },
          child: TextFormField(
            controller: _searchController,
            decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            enabled: false,
            hintText: 'search',
            fillColor:AppColors. whiteColor,
            filled: true,
            border: OutlineInputBorder(borderSide: BorderSide.none)
            ),
            ),
        )
      ),
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                markers: Set<Marker>.of(_markers),
              ),
              elevatedButton(context,
                child:  text("Save",color:AppColors. whiteColor),
                  onPress: () {
                    if (kDebugMode) {
                      print("getLate:  $initialLat");
                      print("getLng:$initialLng");
                       print("change");
                    }
                    
                    finish(context, [
                      _searchController.text.trim(),
                      initialLat,
                      initialLng
                     
                    ]);
                  },
                ).paddingBottom(16)
            ],
          ),
        ),
      ),
    );
  }

  searchLocation() async {
         showDialog(context: context, builder: (context) => Center(child: CustomLoadingIndicator(),),);
    String searchField =_searchController.text;
    List<Location> locations = await locationFromAddress(searchField);
    if (kDebugMode) {
      print(locations.last.longitude);
          print(locations.last.latitude);

    }
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(locations.last.latitude, locations.last.longitude),
        zoom: 17)));
    setState(() {
      _markers.add(Marker(
          markerId: const MarkerId("1"),
          position: LatLng(locations.last.latitude, locations.last.longitude),
          infoWindow: const InfoWindow(title: "My Position")));
    });
    initialLat = locations.last.latitude;
    initialLng = locations.last.longitude;
    finish(context);
    return locations;
  }
  
}








//
 
