import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/firebase_region_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_message_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

// Location Keys
const regionAccountKey = "regionAccount";

// Region Keys
const creatorAccountKey = "creatorAccount";
const imageUrlKey = "imageUrl";
const dateCreatedKey = "dateCreated";
const _dateUpdatedKey = "dateUpdated";
const pointKey = "point";
const geoPointKey = "geopoint";

// Events keys
const eventNameKey = "eventName";
const eventDescriptionKey = "eventDescription";
const eventLocationKey = "eventLocation";
const eventAddressKey = "eventAddress";
const eventImageKey = "eventImage";
const eventStartTimeKey = "eventStartTime";
const eventEndTimeKey = "eventEndTime";
const eventUsersKey = "eventUsers";

// messages
const messageTextKey = "messageText";

class FirebaseDatabaseRegionsRepository extends FirebaseDatabaseService {
  // Init firestore and geoFlutterFire
  final _geo = Geoflutterfire();

  /// Create a region
  Future<Result<String>> createRegion({
    required String regionAccount,
    required String userAccount,
    required double latitude,
    required double longitude,
    required String imageUrl,
  }) {
    final GeoFirePoint regionLocation = _geo.point(latitude: latitude, longitude: longitude);

    final DocumentReference<Object?> regionRef = regionCollection.doc(regionAccount);

    final batch = FirebaseFirestore.instance.batch();

    /// Region Data
    batch.set(
        regionRef,
        {
          creatorAccountKey: userAccount,
          imageUrlKey: imageUrl,
          dateCreatedKey: FieldValue.serverTimestamp(),
          pointKey: regionLocation.data,
        },
        SetOptions(merge: true));

    return batch
        .commit()
        .then((value) => mapFirebaseResponse<String>(() {
              return regionAccount;
            }))
        .onError((error, stackTrace) => mapFirebaseError(stackTrace));
  }

  /// Update a region's Image
  Future<Result<String>> editRegionImage({
    required String imageUrl,
    required String regionAccount,
  }) {
    return regionCollection
        .doc(regionAccount)
        .update(
          {
            imageUrlKey: imageUrl,
            _dateUpdatedKey: FieldValue.serverTimestamp(),
          },
        )
        .then((value) => mapFirebaseResponse<String>(() {
              return regionAccount;
            }))
        .onError((error, stackTrace) => mapFirebaseError(error));
  }

  /// Delete a region and its matching location
  Future<void> deleteRegion(String regionAccount) {
    final batch = FirebaseFirestore.instance.batch();
    batch.delete(regionCollection.doc(regionAccount));
    return batch.commit();
  }

  /// This function returns a Stream of the list of DocumentSnapshot data,
  /// plus some useful metadata like distance from the centerpoint.
  Future<List<FirebaseRegion>> findRegionsByLocation({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    // Create a geoFirePoint
    final GeoFirePoint center = _geo.point(latitude: latitude, longitude: longitude);
    return _geo
        .collection(collectionRef: regionCollection)
        .within(center: center, radius: radius, field: pointKey)
        .asyncMap((List<DocumentSnapshot> event) => event
            // ignore: cast_nullable_to_non_nullable
            .map((DocumentSnapshot document) => FirebaseRegion.fromDocumentSnapshot(document))
            .toList())
        .firstWhere((i) => true);
  }

  Future<Stream<List<FirebaseRegion>>> getAllRegions() async {
    return regionCollection.snapshots().map((QuerySnapshot<Map<String, dynamic>> event) =>
        event.docs.map((region) => FirebaseRegion.fromQueryDocumentSnapshot(region)).toList());
  }

  Future<Result<FirebaseRegion>> getRegionById(String regionId) async {
    return regionCollection
        .doc(regionId)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> document) => mapFirebaseResponse<FirebaseRegion>(() {
              return FirebaseRegion.fromDocumentSnapshot(document);
            }))
        .onError((error, stackTrace) => mapFirebaseError(error));
  }

  Future<Result<String>> createRegionEvent({
    required String eventName,
    required String eventDescription,
    required String regionAccount,
    required String creatorAccount,
    required double latitude,
    required double longitude,
    required String eventAddress,
    required String eventImage,
    required DateTime eventStartTime,
    required DateTime eventEndTime,
  }) async {
    final data = {
      regionAccountKey: regionAccount,
      eventNameKey: eventName,
      eventDescriptionKey: eventDescription,
      creatorAccountKey: creatorAccount,
      eventLocationKey: _geo.point(latitude: latitude, longitude: longitude).data,
      eventAddressKey: eventAddress,
      eventImageKey: eventImage,
      eventStartTimeKey: eventStartTime,
      eventEndTimeKey: eventEndTime,
      dateCreatedKey: FieldValue.serverTimestamp(),
      eventUsersKey: FieldValue.arrayUnion([creatorAccount])
    };

    return regionEventCollection
        .doc()
        .set(data)
        .then((value) => mapFirebaseResponse<String>(() {
              return eventName;
            }))
        .onError((error, stackTrace) => mapFirebaseError(error));
  }

  Future<Result<String>> editRegionEvent({
    required String eventId,
    String? eventName,
    String? eventDescription,
    Place? place,
    String? eventImage,
    DateTime? eventStartTime,
    DateTime? eventEndTime,
  }) async {
    final Map<String, dynamic> data = {};
    if (eventName != null) {
      data.putIfAbsent(eventNameKey, () => eventName);
    }

    if (eventDescription != null) {
      data.putIfAbsent(eventDescriptionKey, () => eventDescription);
    }

    if (place != null) {
      data.putIfAbsent(eventLocationKey, () => _geo.point(latitude: place.lat, longitude: place.lng).data);
      data.putIfAbsent(eventAddressKey, () => place.placeText);
    }

    if (eventImage != null) {
      data.putIfAbsent(eventImageKey, () => eventImage);
    }

    if (eventStartTime != null) {
      data.putIfAbsent(eventStartTimeKey, () => eventStartTime);
    }

    if (eventEndTime != null) {
      data.putIfAbsent(eventEndTimeKey, () => eventEndTime);
    }

    return regionEventCollection
        .doc(eventId)
        .set(data, SetOptions(merge: true))
        .then((value) => mapFirebaseResponse<String>(() {
              return eventId;
            }))
        .onError((error, stackTrace) => mapFirebaseError(error));
  }

  Future<Result<String>> deleteRegionEvent({required String eventId}) async {
    return regionEventCollection
        .doc(eventId)
        .delete()
        .then((value) => mapFirebaseResponse<String>(() {
              return eventId;
            }))
        .onError((error, stackTrace) => mapFirebaseError(error));
  }

  Stream<List<RegionEventModel>> getEventsForRegion(String regionAccount) {
    return regionEventCollection.where(regionAccountKey, isEqualTo: regionAccount).snapshots().asyncMap(
        (QuerySnapshot event) => event.docs
            .map((QueryDocumentSnapshot event) =>
                RegionEventModel.mapToRegionEventModel(event as QueryDocumentSnapshot<Map<String, dynamic>>))
            .toList());
  }

  Stream<RegionEventModel> getEventRegion(String regionId) {
    return regionEventCollection.where('id', isEqualTo: regionId).snapshots().asyncMap((QuerySnapshot event) {
      return RegionEventModel.mapToRegionEventModel(event as QueryDocumentSnapshot<Map<String, dynamic>>);
    });
  }

  Future<Result<String>> joinEvent(String eventId, String joiningUser) {
    final data = {
      eventUsersKey: FieldValue.arrayUnion([joiningUser]),
    };

    return regionEventCollection
        .doc(eventId)
        .set(data, SetOptions(merge: true))
        .then((value) => mapFirebaseResponse<String>(() {
              return eventId;
            }))
        .onError((error, stackTrace) => mapFirebaseError(error));
  }

  Future<Result<String>> leaveEvent(String eventId, String leavingUser) {
    final data = {
      eventUsersKey: FieldValue.arrayRemove([leavingUser]),
    };

    return regionEventCollection
        .doc(eventId)
        .set(data, SetOptions(merge: true))
        .then((value) => mapFirebaseResponse<String>(() {
              return eventId;
            }))
        .onError((error, stackTrace) => mapFirebaseError(error));
  }

  Future<Result<String>> sendMessageToRegion(String regionAccount, String creatorAccount, String message) {
    final data = {
      regionAccountKey: regionAccount,
      creatorAccountKey: creatorAccount,
      dateCreatedKey: FieldValue.serverTimestamp(),
      messageTextKey: message
    };

    return regionMessageCollection
        .doc()
        .set(data)
        .then((value) => mapFirebaseResponse<String>(() {
              return creatorAccount;
            }))
        .onError((error, stackTrace) => mapFirebaseError(error));
  }

  Stream<List<RegionMessageModel>> getMessagesForRegion(String regionAccount) {
    return regionMessageCollection.where(regionAccountKey, isEqualTo: regionAccount).snapshots().asyncMap(
        (QuerySnapshot event) => event.docs
            .map((QueryDocumentSnapshot event) => RegionMessageModel.mapToRegionMessageModel(event))
            .toList());
  }
}
