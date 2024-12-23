import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricai/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CloudSession {
  final String documentId;
  final String ownerUserId;
  final String name;
  final Timestamp time;
  final String shotType;
  final List<dynamic> videos;

  const CloudSession({
    required this.documentId,
    required this.ownerUserId,
    required this.name,
    required this.time,
    required this.shotType,
    required this.videos,
  });

//We are taking a snapshot of a session in a document and making a session from it.
  CloudSession.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        name = snapshot.data()[nameFieldName] as String,
        time = snapshot.data()[timeFieldName] as Timestamp,
        shotType = snapshot.data()[shotTypeFieldName] as String,
        videos = snapshot.data()[videosFieldName] as List<dynamic>;

  CloudSession.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.get(ownerUserIdFieldName),
        name = snapshot.get(nameFieldName) as String,
        time = snapshot.get(timeFieldName) as Timestamp,
        shotType = snapshot.get(shotTypeFieldName) as String,
        videos = snapshot.get(videosFieldName) as List<dynamic>;
}
