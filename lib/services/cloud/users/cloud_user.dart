import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricai/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CloudUser {
  final String documentId;
  final String ownerUserId;
  final String name;
  final String email;
  final String userType;

  const CloudUser({
    required this.documentId,
    required this.ownerUserId,
    required this.name,
    required this.email,
    required this.userType,
  });

//We are taking a snapshot of a user in a document and making a user from it.
  CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        name = snapshot.data()[nameFieldName] as String,
        email = snapshot.data()[emailFieldName] as String,
        userType = snapshot.data()[userTypeFieldName] as String;
}
