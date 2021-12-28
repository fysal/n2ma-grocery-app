import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:n2ma/tools/customColors.dart';

class UserLocation extends StatefulWidget {
  State<StatefulWidget> createState() => _UserLocation();
}

class _UserLocation extends State<UserLocation> {
  GoogleMapController mapController;
  Marker marker;
  TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (value) => null,
            initialCameraPosition: CameraPosition(
              target: LatLng(0.3476, 32.5825),
              zoom: 15,
            ),
            markers: Set<Marker>(),
            mapType: MapType.normal,
            compassEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) => setState(() {
              mapController = controller;
            }),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FlatButton(
              onPressed: () => _addMaker(),
              color: green,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 50,
              ),
            ),
          )
        ],
      ),
    );
  }

  _addMaker() {
    marker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(20.47, 11.41),
      infoWindow:
          InfoWindow(title: 'my location', snippet: '', onTap: () => null),
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: marker.position)));
  }
}
