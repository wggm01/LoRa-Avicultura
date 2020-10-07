import 'package:flutter/material.dart';
import 'package:lora_avicultura/paginas/vista_resumida.dart';
import 'package:lora_avicultura/paginas/vista_scatter.dart';
import 'package:lora_avicultura/paginas/ubicacion_nodos.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final tabs = [
    VistaResumida(),
    VistaScatter(),
    NodosMap(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoRa Farm') ,
        centerTitle: true,
        elevation: 1.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.healing_outlined),
              title: Text('Salud del sistema'),
              onTap: () {
                //Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.business_center_outlined),
              title: Text('Registro de errores'),
              onTap: () {
                //Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Acerca del app'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Sistema de monitoreo de animales de granja',
                  applicationVersion: 'Version : Beta',
                  applicationIcon: Icon(Icons.app_settings_alt_outlined),

                );
              },
            ),
          ],
        ),
      ),


      body:tabs[_currentIndex],


      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.table_chart_outlined),
              label: 'Vista Resumida'
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Vista grafica'),

          BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Ubicaciones'),
        ],
        selectedItemColor: Colors.blue[800],
        onTap: (index) {
          setState(() {
            _currentIndex =index;
          });
        },

      ),
    );
  }
}

