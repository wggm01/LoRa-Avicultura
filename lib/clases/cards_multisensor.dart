import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardSensor extends StatefulWidget {

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

  @override
  _CardSensorState createState() => _CardSensorState();
}



class _CardSensorState extends State<CardSensor> {
  Map<String, dynamic> get documento {
    return widget.snapshot.data();
  }

  shDialog(BuildContext context) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Valores por mes:'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('Agua consumida:' + documento['promedio'][0].toString()),
              Text('Alimento consumido:' + documento['promedio'][1].toString()),
              Text('Temperatura promedio:'+ documento['promedio'][2].toString()),
              Text('Humedad promedio:'+ documento['promedio'][3].toString()),
              Text('Presión promedio:'+ documento['promedio'][4].toString()),
              Text('IAQ promedio:'+ documento['promedio'][5].toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Salir'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    });
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  documento['nombre_corral'],
                  style: CardSensor.headLabel,
                ),
                IconButton(
                  splashRadius: 25.0,
                  padding: EdgeInsets.all(0),
                  color: Colors.red,
                  highlightColor: Colors.pink,
                  icon: Icon(Icons.list_alt_sharp),
                    onPressed: (){
                      shDialog(context);
                })
              ],
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
                      style: CardSensor.valueLabel,
                    ),
                    Text(
                      'Agua',
                      style: CardSensor.sensorLabel,
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
                      style: CardSensor.valueLabel,
                    ),
                    Text(
                      'Alimento',
                      style: CardSensor.sensorLabel,
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
                      style: CardSensor.valueLabel,
                    ),
                    Text(
                      'Temperatura',
                      style: CardSensor.sensorLabel,
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
                      style: CardSensor.valueLabel,
                    ),
                    Text(
                      'Humedad',
                      style: CardSensor.sensorLabel,
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.redAccent,
                child: Column(
                  children: [
                    Text(
                      documento['medidas'][4].toString()+ 'Khpa',
                      style: CardSensor.valueLabel,
                    ),
                    Text(
                      'Presión',
                      style: CardSensor.sensorLabel,
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.redAccent,
                child: Column(
                  children: [
                    Text(
                      documento['medidas'][5].toString(),
                      style: CardSensor.valueLabel,
                    ),
                    Text(
                      'IAQ',
                      style: CardSensor.sensorLabel,
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
            child: Text(documento['fecha_hora'],style: CardSensor.headLabel,),
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),

            //color: Colors.cyanAccent,
          ),
        ],
      ),
    );
  }
}
/*

 */