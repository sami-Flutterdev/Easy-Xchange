import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class AddressFromCoordinatesScreen extends StatefulWidget {
  const AddressFromCoordinatesScreen({super.key});

  @override
  _AddressFromCoordinatesScreenState createState() =>
      _AddressFromCoordinatesScreenState();
}

class _AddressFromCoordinatesScreenState
    extends State<AddressFromCoordinatesScreen> {
  String? address;

  Future<void> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        address =
            '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      });
    } catch (e) {
      print(e);
    }
  }

  void showAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Address'),
          content: address != null ? Text(address!) : Text('Address not found'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Address from Coordinates'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {},
          child: Text('Get Address'),
        ),
      ),
    );
  }
}
