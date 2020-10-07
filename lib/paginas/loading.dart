import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

   bool connflag = false;

  check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      setState(() {
        connflag = false;
      });
      await Firebase.initializeApp();
      await FirebaseFirestore.instance.collection('nodos').get();
      Navigator.pushNamed(context, '/home');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      setState(() {
        connflag = false;
      });
      await Firebase.initializeApp();
      await FirebaseFirestore.instance.collection('nodos').get();
      Navigator.pushNamed(context, '/home');
    }
    else{
      setState(() {
        connflag = true;
      });
    }


  }

  static const TextStyle headLabel = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,

  );

  Widget _onNetstate() {

    if(connflag == false){

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(
              color: Colors.white,
              size: 50.0,
            ),
            Container(
              child: Text('LoRa Farm', style: headLabel,),
            ),
          ],
        );
    }

    else if (connflag==true){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text('Error de conexión: Compruebe su conexión WiFi o Mobile',
                  style: headLabel,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: RaisedButton(
                child: Text('Reintentar',style: headLabel,),
                onPressed: () {
                  setState(() {
                    check();
                  });
                },
              ),
            ),
          ],
        );
    }
    else{
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    check();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: _onNetstate(),
    );
  }
}


