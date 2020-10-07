import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lora_avicultura/clases/cards_permonth.dart';

class VistaMes extends StatelessWidget {
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
                  if(stream.connectionState == ConnectionState.waiting){return Center(child: LinearProgressIndicator());}
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: stream.data.size,
                      itemBuilder: (context, index) => CardPermonth(stream.data.docs[index])
                  );
                }
            );
          }
          else{return Center(child: LinearProgressIndicator());}
        }
    );


  }
}
