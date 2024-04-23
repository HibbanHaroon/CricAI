import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricai/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CloudPlayer {
  final String documentId;
  final String coachId;
  final String playerId;

  const CloudPlayer({
    required this.documentId,
    required this.coachId,
    required this.playerId,
  });

//We are taking a snapshot of a session in a document and making a session from it.
  CloudPlayer.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        coachId = snapshot.data()[coachIdFieldName],
        playerId = snapshot.data()[playerIdFieldName] as String;

  CloudPlayer.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : documentId = snapshot.id,
        coachId = snapshot.get(coachIdFieldName),
        playerId = snapshot.get(playerIdFieldName) as String;
}
