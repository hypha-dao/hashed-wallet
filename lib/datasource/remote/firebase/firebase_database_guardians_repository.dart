import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/datasource/local/models/account.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardians_data.dart';

class FirebaseDatabaseGuardiansRepository extends FirebaseDatabaseService {
  bool hasGuardianNotificationPending(String userAccount) {
    return false;
  }

  List<Account> getGuardiansForUser11(String userId) {
    return [
      const Account(address: "walletAddress", name: 'GERY'),
      const Account(address: "walletAddress1", name: 'Nik'),
      const Account(address: "walletAddress3", name: 'Gaby')
    ];
  }

  GuardiansData getGuardiansDataForUse11r(String userId) {
    return GuardiansData(true, [
      const Account(address: "walletAddress"),
      const Account(address: "walletAddress1", name: 'Nik'),
      const Account(address: "walletAddress3", name: 'Gaby')
    ]);
  }

  Stream<bool> isGuardiansInitialized(String userAccount) {
    return Stream.value(false);
  }

  /// Use only when we have successfully saved guardians to the user contract by calling eosService.initGuardians
  bool setGuardiansInitialized(String userAccount) {
    return true;
  }

  // This methods finds all the myGuardians for the {userId} and removes the RECOVERY_APPROVED_DATE_KEY for each one of them.
// Then it goes over to each user and removes the field from the users collection as well.
  Future<void> stopRecoveryForUser(String currentUserId) async {}

  /// Use only when we have successfully saved guardians to the user contract by calling eosService.initGuardians
  Future<void> setGuardiansInitializedUpdated(String userAccount) {
    final data = <String, Object>{
      GUARDIAN_CONTRACT_INITIALIZED: true,
      GUARDIAN_CONTRACT_INITIALIZED_UPDATE_DATE: FieldValue.serverTimestamp(),
    };
    return usersCollection.doc(userAccount).set(data, SetOptions(merge: true));
  }

  Future<void> removeGuardiansInitialized(String userAccount) {
    final data = <String, Object?>{
      GUARDIAN_CONTRACT_INITIALIZED: false,
      GUARDIAN_CONTRACT_INITIALIZED_UPDATE_DATE: FieldValue.serverTimestamp(),
      GUARDIAN_RECOVERY_STARTED_KEY: null,
    };
    return usersCollection.doc(userAccount).set(data, SetOptions(merge: true));
  }

  Future<void> setGuardianRecoveryStarted(String userAccount) {
    final data = <String, Object>{
      GUARDIAN_RECOVERY_STARTED_KEY: FieldValue.serverTimestamp(),
    };
    return usersCollection.doc(userAccount).set(data, SetOptions(merge: true));
  }

  Future<void> removeGuardianRecoveryStarted(String userAccount) {
    final data = <String, Object?>{
      GUARDIAN_RECOVERY_STARTED_KEY: null,
    };
    return usersCollection.doc(userAccount).set(data, SetOptions(merge: true));
  }

  Future<void> removeGuardianNotification(String userAccount) {
    final data = <String, Object>{GUARDIAN_NOTIFICATION_KEY: false};

    return usersCollection
        .doc(userAccount)
        .collection(PENDING_NOTIFICATIONS_KEY)
        .doc(GUARDIAN_NOTIFICATION_KEY)
        .set(data, SetOptions(merge: true));
  }
}

// Manage guardian Ids
// ignore: unused_element
String _createGuardianId({required String currentUserId, required String otherUserId}) {
  return '$currentUserId-$otherUserId';
}
