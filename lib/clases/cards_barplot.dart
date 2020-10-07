import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
class CardBarplot extends StatelessWidget {

  final DocumentSnapshot snapshot;
  CardBarplot(this.snapshot);
  Map<String, dynamic> get documento {
    return snapshot.data();
  }

  static const TextStyle headLabel = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,

  );

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    var screenSize = deviceData.size;
    var adjMargin = screenSize.width/30;
    return Card(
        margin: EdgeInsets.fromLTRB(adjMargin, 16.0,adjMargin , 0.0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //color: const Color(0xffffffff),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(documento['nombre_corral'],
              style: headLabel,),
          ),
          Divider(
            thickness: 2.5,
            height: 20.0,
          ),
          AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                minY: 5,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: const EdgeInsets.all(0),
                    tooltipBottomMargin: 8,
                    getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                        ) {
                      return BarTooltipItem(
                        rod.y.round().toString(),
                        TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    textStyle: TextStyle(
                        color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 11),
                    margin: 5,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'Agua[L]';
                        case 1:
                          return 'Comida[g]';
                        case 2:
                          return 'Temp[°C]';
                        case 3:
                          return 'Humedad[%]';
                        case 4:
                          return 'Presión[pa]';
                        case 5:
                          return 'Gas[mol]';
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(showTitles: false),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: [
                  BarChartGroupData(
                      x: 0,
                      barRods: [BarChartRodData(y: documento['medidas'][0].toDouble(), color: Colors.lightBlueAccent)],
                      showingTooltipIndicators: [0]),
                  BarChartGroupData(
                      x: 1,
                      barRods: [BarChartRodData(y: documento['medidas'][1].toDouble(), color: Colors.lightBlueAccent)],
                      showingTooltipIndicators: [0]),
                  BarChartGroupData(
                      x: 2,
                      barRods: [BarChartRodData(y: documento['medidas'][2].toDouble(), color: Colors.lightBlueAccent)],
                      showingTooltipIndicators: [0]),
                  BarChartGroupData(
                      x: 3,
                      barRods: [BarChartRodData(y: documento['medidas'][3].toDouble(), color: Colors.lightBlueAccent)],
                      showingTooltipIndicators: [0]),
                  BarChartGroupData(
                      x: 4,
                      barRods: [BarChartRodData(y: documento['medidas'][4].toDouble(), color: Colors.lightBlueAccent)],
                      showingTooltipIndicators: [0]),
                  BarChartGroupData(
                      x: 5,
                      barRods: [BarChartRodData(y: documento['medidas'][5].toDouble(), color: Colors.lightBlueAccent)],
                      showingTooltipIndicators: [0]),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2.5,
            height: 20.0,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(documento['fecha_hora'],
              style: headLabel,),
          ),
        ],
      )
    );
  }
}



