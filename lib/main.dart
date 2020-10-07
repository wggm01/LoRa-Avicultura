import 'package:flutter/material.dart';
import 'package:lora_avicultura/paginas/loading.dart';
import 'package:lora_avicultura/paginas/home.dart';
import 'package:lora_avicultura/paginas/vista_resumida.dart';
import 'package:lora_avicultura/paginas/vista_scatter.dart';
import 'package:lora_avicultura/paginas/ubicacion_nodos.dart';
//import 'package:lora_avicultura/paginas/salud_sistema.dart';
//import 'package:lora_avicultura/paginas/registro_errores.dart';

/*
todo 1. agregar notificaciones
todo 2. agregar dialog box a vista resumida para ver los valores por mes.
 */

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':(context) => Loading(),
        '/home':(context) => Home(),
        '/vista_resumida':(context) => VistaResumida(),
        '/vista_scatter':(context) => VistaScatter(),
        '/ubicacion_nodos':(context) => NodosMap(),
        //'/salud_sistema':(context) => SaludSistema(),
        //'/registro_errores':(context) => RegistroErrores(),
      },
  ));
}

