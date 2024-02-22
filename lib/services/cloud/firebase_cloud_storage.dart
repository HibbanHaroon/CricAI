import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricai/services/cloud/cloud_user.dart';
import 'package:cricai/services/cloud/cloud_storage_constants.dart';
import 'package:cricai/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  //grabbing all the users from the collection 'users'
  final users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser({
    required String ownerUserId,
    required String name,
    required String userType,
  }) async {
    try {
      await users.add({
        ownerUserIdFieldName: ownerUserId,
        nameFieldName: name,
        userTypeFieldName: userType,
      });
    } catch (e) {
      CouldNotCreateUserException();
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

  Future<void> updateUser({
    required String documentId,
    required String name,
    required String userType,
  }) async {
    try {
      await users.doc(documentId).update({
        nameFieldName: name,
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

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  //This is a private constructor of the class FirebaseCloudStorage
  FirebaseCloudStorage._sharedInstance();
  //This is a factory constructor which will talk with the private static field above,
  //which in turns calls the above private constructor.

  //This is how we make this class a singleton
  factory FirebaseCloudStorage() => _shared;
}
