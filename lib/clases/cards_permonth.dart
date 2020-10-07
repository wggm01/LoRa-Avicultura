import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardPermonth extends StatelessWidget {
  final DocumentSnapshot snapshot;
  CardPermonth(this.snapshot);
  Map<String, dynamic> get documento {
    return snapshot.data();
  }

  static const TextStyle headLabel = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle valueLabel = TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(documento['nombre_corral'],
              style: headLabel,)
          ),
          GridView.count(
            crossAxisCount: 3,
            //scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 1.0,
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Agua',
                        style: valueLabel
                    ),
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: Image(
                        image: AssetImage('assets/drink-water.png'),
                      ),
                    ),
                    Text(
                        documento['medidas'][0].toString() + 'L',
                      style: valueLabel
                    )
                  ],
                ),
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Alimento',
                        style: valueLabel
                    ),
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: Image(
                        image: AssetImage('assets/food.png'),
                      ),
                    ),
                    Text(
                        documento['medidas'][1].toString() + 'g',
                        style: valueLabel
                    )
                  ],
                ),
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Temperatura',
                        style: valueLabel
                    ),
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: Image(
                        image: AssetImage('assets/thermometer.png'),
                      ),
                    ),
                    Text(
                        documento['medidas'][2].toString() + '°C',
                        style: valueLabel
                    )
                  ],
                ),
              ),
            ],
          ),

          GridView.count(
            crossAxisCount: 3,
            //scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Humedad',
                        style: valueLabel
                    ),
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: Image(
                        image: AssetImage('assets/humidity.png'),
                      ),
                    ),
                    Text(
                        documento['medidas'][3].toString() + '%',
                        style: valueLabel
                    )
                  ],
                ),
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Presión',
                        style: valueLabel
                    ),
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: Image(
                        image: AssetImage('assets/barometer.png'),
                      ),
                    ),
                    Text(
                        documento['medidas'][4].toString() + 'bar',
                        style: valueLabel
                    )
                  ],
                ),
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'IAQ',
                        style: valueLabel
                    ),
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: Image(
                        image: AssetImage('assets/barometer.png'),
                      ),
                    ),
                    Text(
                        documento['medidas'][5].toString() + 'mol',
                        style: valueLabel
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      )
    );

  }
}

