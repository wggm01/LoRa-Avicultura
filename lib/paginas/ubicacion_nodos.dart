import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NodosMap extends StatefulWidget {
  @override
  _NodosMapState createState() => _NodosMapState();
}

class _NodosMapState extends State<NodosMap> {

  GoogleMapController _controller;
  BitmapDescriptor _markerIcon;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final CameraPosition _homeposition = CameraPosition(
      target: LatLng(8.426252, -81.059752),
      zoom: 6.9
  );

  void initMarker(documento, documentoid) async{
    _markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/location.png');
    var markerIdVal = documentoid;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position:
      LatLng(documento['ubicacion'].latitude, documento['ubicacion'].longitude),
       infoWindow: InfoWindow(title: 'Granja', snippet: documento['nombre_corral']),
      icon: _markerIcon
    );
    setState(() {
      markers[markerId] = marker;
    });

  }

  getMarkerData() async {
    Firebase.initializeApp();
    FirebaseFirestore.instance.collection('nodos').get().then((retrived) {
      if (retrived.docs.isNotEmpty) {
        for (int i = 0; i < retrived.docs.length; i++) {
          //print(retrived.docs[i].data());
          initMarker(retrived.docs[i].data(), retrived.docs[i].id);
        }
      }
    });
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  shAll (){
    _controller.moveCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(8.426252, -81.059752),zoom: 6.9)
        )
    );
  }

  @override
  void initState() {
    super.initState();
    getMarkerData();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
               markers: Set<Marker>.of(markers.values),
            mapType: MapType.normal,
            initialCameraPosition:_homeposition,
            onMapCreated: mapCreated,
        ),
        Container(
          child:
              RaisedButton(
                child: Text('Mostrar todos'),
                 onPressed: () {
                   setState(() {
                       shAll();
                   });
                 }
              )
        )
      ],
    );

   }
}


