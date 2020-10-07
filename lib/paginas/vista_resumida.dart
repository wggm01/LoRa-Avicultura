import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lora_avicultura/clases/cards_multisensor.dart';



class VistaResumida extends StatelessWidget {
  final Future _fbini = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fbini ,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('nodos').snapshots(),
                builder: (context, stream) {
                  if(stream.connectionState == ConnectionState.waiting){return LinearProgressIndicator();}
                  return ListView.builder(
                      itemCount: stream.data.size,
                      itemBuilder: (context, index) => CardSensor(stream.data.docs[index])
                  );
                }
            );
          }
          else{return Center(child: LinearProgressIndicator());}
        }
    );
  }
}


