import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricai/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CloudSession {
  final String documentId;
  final String ownerUserId;
  final String name;
  final Timestamp time;
  final List<dynamic> videos;

  const CloudSession({
    required this.documentId,
    required this.ownerUserId,
    required this.name,
    required this.time,
    required this.videos,
  });

//We are taking a snapshot of a session in a document and making a session from it.
  CloudSession.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        name = snapshot.data()[nameFieldName] as String,
        time = snapshot.data()[timeFieldName] as Timestamp,
        videos = snapshot.data()[videosFieldName] as List<dynamic>;
}
