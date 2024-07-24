import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CandidatosWidget extends StatelessWidget {
  final CollectionReference _candidatosRef = FirebaseFirestore.instance.collection('candidatos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Votar')),
      body: StreamBuilder(
        stream: _candidatosRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Card(
                child: ListTile(
                  leading: Image.network(doc['urlImagen']),
                  title: Text(doc['nombrePartido']),
                  subtitle: Text(doc['representante']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          _updateVotes(doc.id, (doc['cantidadVotos'] as int) - 1);
                        },
                      ),
                      Text(doc['cantidadVotos'].toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          _updateVotes(doc.id, (doc['cantidadVotos'] as int) + 1);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _updateVotes(String id, int newVotes) {
    _candidatosRef.doc(id).update({'cantidadVotos': newVotes});
  }
}
