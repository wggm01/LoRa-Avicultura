import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NodosMap extends StatefulWidget {


  @override
  _NodosMapState createState() => _NodosMapState();
}

class _NodosMapState extends State<NodosMap> {
  //--todo 1.Cambiar icono de marcador
  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(documento, documentoid){
    var markerIdVal = documentoid;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position:
      LatLng(documento['ubicacion'].latitude, documento['ubicacion'].longitude),
      infoWindow: InfoWindow(title: 'Granja', snippet: documento['nombre_corral']),
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

  @override
  void initState() {
    getMarkerData();
    super.initState();
  }



  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            markers: Set<Marker>.of(markers.values),
            mapType: MapType.normal,
            initialCameraPosition:
            CameraPosition(target: LatLng(8.426252, -81.059752), zoom: 6.9),
            onMapCreated: (GoogleMapController controller) {
              controller = controller;
            }
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Text('Ubicación de los nodos y gateway'),
        )
      ],
    );


  }
}

/*


 */
