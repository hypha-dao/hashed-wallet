// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hashed/utils/result_extension.dart';

const String FIREBASE_DATABASE_USERS_COLLECTION = 'users';

const String UID_KEY = 'uid';
const String TYPE_KEY = 'type';
const String FIREBASE_MESSAGE_TOKENS_KEY = 'firebaseMessageTokens';
const String USER_PHONE_NUMBER_KEY = 'phoneNumber';

abstract class FirebaseDatabaseService {
  CollectionReference get usersCollection => FirebaseFirestore.instance.collection(FIREBASE_DATABASE_USERS_COLLECTION);

  FutureOr<Result<T>> mapFirebaseResponse<T>(T Function() modelMapper) {
    //print('Model Class: $modelMapper');
    return Result.value(modelMapper());
  }

  ErrorResult mapFirebaseError(dynamic error) {
    print('mapFirebaseError: $error');
    return ErrorResult(error as Object);
  }
}

extension QueryDocumentSnapshotGetOrDefault<T> on QueryDocumentSnapshot<Map<String, dynamic>> {
  T getOrDefault(String key, T defaultValue) {
    return data().containsKey(key) ? this[key] as T ?? defaultValue : defaultValue;
  }
}
