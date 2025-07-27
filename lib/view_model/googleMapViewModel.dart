import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:uuid/uuid.dart';

class GoogleMapViewModel with ChangeNotifier{
   
 // little vit changes
 String sessionToken = Uuid().v4();
  List<dynamic> playList = [];

  void updateSessionToken() {
    sessionToken = Uuid().v4();
  }
 //  update playList
  void updatePlayList(List<dynamic> list) {
    playList = list;
    notifyListeners();
  }

  // update search Controller
  var searchController;

  void updateSearchController(search) {
    searchController = search;
    //  print(search);
    onChange();
   
  } 

  onChange(){
  updateSessionToken();
  getSession(searchController);

  }

// get Session

  getSession(String input)async{
    String baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
  var kplacesApiKey = 'AIzaSyDAyLGkqWfNjptjFdq11tz7wayU_nmVTLY';
  String request = '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$sessionToken';


    var response = await http.get(Uri.parse(request));
    // print(response.body);
    // print(response.statusCode);
   if(response.statusCode == 200||response.statusCode == 201 ){
         playList = jsonDecode(response.body)['predictions'];
         updatePlayList(playList);
   }else{
    throw Exception('Error failed to load');
   }
  }
  }