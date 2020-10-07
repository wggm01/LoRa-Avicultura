import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardSensor extends StatelessWidget {

  static const TextStyle sensorLabel = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal
  );
  static const TextStyle valueLabel = TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold
  );
  static const TextStyle headLabel = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,

  );

  final DocumentSnapshot snapshot;
  CardSensor(this.snapshot);
  Map<String, dynamic> get documento {
    return snapshot.data();
  }

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    var screenSize = deviceData.size;
    var adjMargin = screenSize.width/40;

    return Card(
      elevation: 1.0,
      margin: EdgeInsets.fromLTRB(adjMargin, 16.0,adjMargin , 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(
              documento['nombre_corral'],
              style: headLabel,
            ),
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            //color: Colors.greenAccent,
          ),
          Divider(
            thickness: 2.5,
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                //color: Colors.redAccent,
                child: Column(
                  children: [
                    Text(
                      documento['medidas'][0].toString() + 'L',
                      style: valueLabel,
                    ),
                    Text(
                      'Agua',
                      style: sensorLabel,
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.redAccent,
                child: Column(
                  children: [
                    Text(
                      documento['medidas'][1].toString()+ 'g',
                      style: valueLabel,
                    ),
                    Text(
                      'Alimento',
                      style: sensorLabel,
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.redAccent,
                child: Column(
                  children: [
                    Text(
                      documento['medidas'][2].toString()+ '°C',
                      style: valueLabel,
                    ),
                    Text(
                      'Temperatura',
                      style: sensorLabel,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2.5,
            height: 20.0,
            indent: 20.0,
            endIndent: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                //color: Colors.redAccent,
                child: Column(
                  children: [
                    Text(
                      documento['medidas'][3].toString()+ '%',
                      style: valueLabel,
                    ),
                    Text(
                      'Humedad',
                      style: sensorLabel,
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.redAccent,
                child: Column(
                  children: [
                    Text(
                      documento['medidas'][4].toString()+ 'bar',
                      style: valueLabel,
                    ),
                    Text(
                      'Presión',
                      style: sensorLabel,
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.redAccent,
                child: Column(
                  children: [
                    Text(
                      documento['medidas'][5].toString()+ 'mol',
                      style: valueLabel,
                    ),
                    Text(
                      'Gas',
                      style: sensorLabel,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2.5,
            height: 20.0,
          ),
          Container(
            child: Text(documento['fecha_hora'],style: headLabel,),
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),

            //color: Colors.cyanAccent,
          ),
        ],
      ),
    );
  }
}
