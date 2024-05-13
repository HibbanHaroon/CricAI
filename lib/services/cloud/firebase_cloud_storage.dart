import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricai/services/cloud/players/cloud_players.dart';
import 'package:cricai/services/cloud/sessions/cloud_session.dart';
import 'package:cricai/services/cloud/users/cloud_user.dart';
import 'package:cricai/services/cloud/cloud_storage_constants.dart';
import 'package:cricai/services/cloud/cloud_storage_exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseCloudStorage {
  //grabbing all the users from the collection 'users'
  final users = FirebaseFirestore.instance.collection('users');
  final sessions = FirebaseFirestore.instance.collection('sessions');
  final players = FirebaseFirestore.instance.collection('players');
  final _videosStorage = FirebaseStorage.instance;

  Future<void> createUser({
    required String ownerUserId,
    required String name,
    required String email,
    required String userType,
  }) async {
    try {
      await users.add({
        ownerUserIdFieldName: ownerUserId,
        nameFieldName: name,
        emailFieldName: email,
        userTypeFieldName: userType,
      });
    } catch (e) {
      throw CouldNotCreateUserException();
    }
  }

  Future<CloudUser> getUser({required String ownerUserId}) async {
    //get info of the current user
    try {
      var querySnapshot = await users
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return CloudUser.fromSnapshot(querySnapshot.docs.first);
      } else {
        throw CouldNotGetUserException();
      }
    } catch (e) {
      throw CouldNotGetUserException();
    }
  }

  Future<String> getUserIdByEmail({required String email}) async {
    //get user id of the user with the given email
    try {
      var querySnapshot = await users
          .where(
            emailFieldName,
            isEqualTo: email,
          )
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return CloudUser.fromSnapshot(querySnapshot.docs.first).ownerUserId;
      } else {
        throw CouldNotGetUserException();
      }
    } catch (e) {
      throw CouldNotGetUserException();
    }
  }

  Future<void> updateUser({
    required String documentId,
    required String name,
    required String email,
    required String userType,
  }) async {
    try {
      await users.doc(documentId).update({
        nameFieldName: name,
        emailFieldName: email,
        userTypeFieldName: userType,
      });
    } catch (e) {
      throw CouldNotUpdateUserException();
    }
  }

  Future<void> deleteUser({
    required String documentId,
  }) async {
    try {
      await users.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteUserException();
    }
  }

  // Uploads a video to a Firebase Storage in a sessions folder. Each Session will have it's own folder represented by the sessionId.
  Future<String> uploadVideo(
      String videoName, String videoPath, String sessionId) async {
    Reference ref = _videosStorage
        .ref()
        .child('sessions/$sessionId/$videoName/raw_video.mp4');
    await ref.putFile(File(videoPath));
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> createSession({
    required String ownerUserId,
    required String name,
    required String shotType,
    required List<dynamic> videos,
  }) async {
    try {
      var docRef = await sessions.add({
        ownerUserIdFieldName: ownerUserId,
        nameFieldName: name,
        timeFieldName: FieldValue.serverTimestamp(),
        shotTypeFieldName: shotType,
        videosFieldName: videos,
      });
      return docRef.id;
    } catch (e) {
      throw CouldNotCreateSessionException();
    }
  }

  Stream<List<CloudSession>> allSessions({required String ownerUserId}) =>
      sessions.snapshots().map((event) => event.docs
          .map((doc) => CloudSession.fromSnapshot(doc))
          .where((session) => session.ownerUserId == ownerUserId)
          .toList());

  Future<void> updateSession({
    required String documentId,
    required String name,
    required String shotType,
    required List<dynamic> videos,
  }) async {
    try {
      await sessions.doc(documentId).update({
        nameFieldName: name,
        shotTypeFieldName: shotType,
        videosFieldName: videos,
      });
    } catch (e) {
      throw CouldNotUpdateSessionException();
    }
  }

  Future<void> deleteSession({
    required String documentId,
  }) async {
    try {
      await sessions.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteSessionException();
    }
  }

  Future<CloudSession> getSession({
    required String ownerUserId,
    required String documentId,
  }) async {
    try {
      var documentSnapshot = await sessions.doc(documentId).get();

      if (documentSnapshot.exists) {
        CloudSession session =
            CloudSession.fromDocumentSnapshot(documentSnapshot);
        return session;
      } else {
        throw CouldNotGetSessionException();
      }
    } catch (e) {
      throw CouldNotGetSessionException();
    }
  }

  Future<String> addPlayer({
    required String coachId,
    required String playerId,
  }) async {
    try {
      var docRef = await players.add({
        coachIdFieldName: coachId,
        playerIdFieldName: playerId,
      });
      return docRef.id;
    } catch (e) {
      throw CouldNotAddPlayerException();
    }
  }

  Future<void> deletePlayer({
    required String documentId,
  }) async {
    try {
      await players.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeletePlayerException();
    }
  }

  Stream<List<CloudPlayer>> allPlayers({required String coachId}) =>
      players.snapshots().map((event) => event.docs
          .map((doc) => CloudPlayer.fromSnapshot(doc))
          .where((player) => player.coachId == coachId)
          .toList());

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  //This is a private constructor of the class FirebaseCloudStorage
  FirebaseCloudStorage._sharedInstance();
  //This is a factory constructor which will talk with the private static field above,
  //which in turns calls the above private constructor.

  //This is how we make this class a singleton
  factory FirebaseCloudStorage() => _shared;
}
