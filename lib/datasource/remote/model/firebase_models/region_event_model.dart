import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';

class RegionEventModel {
  final String id;
  final String regionAccount;
  final String creatorAccount;
  final String eventName;
  final String eventDescription;
  final GeoPoint eventLocation;
  final String eventAddress;
  final String eventImage;
  final Timestamp eventStartTime;
  final Timestamp eventEndTime;
  final Timestamp createdTime;
  final List<String> users;

  RegionEventModel({
    required this.id,
    required this.regionAccount,
    required this.creatorAccount,
    required this.eventName,
    required this.eventDescription,
    required this.eventLocation,
    required this.eventAddress,
    required this.eventImage,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.users,
    required this.createdTime,
  });

  String get readableMembersCount {
    return users.length > 1000 ? '${users.length.toStringAsFixed(1)} K' : users.length.toString();
  }

  String get formattedStartTime => DateFormat.jm().format(DateTime.parse(eventStartTime.toDate().toString()));

  String get formattedStartDate =>
      DateFormat('EEEE, MMM d, y - h:mm a').format(DateTime.parse(eventStartTime.toDate().toString()));

  String get formattedEndTime => DateFormat.jm().format(DateTime.parse(eventEndTime.toDate().toString()));

  String get formattedEndDate =>
      DateFormat('EEEE, MMM d, y - h:mm a').format(DateTime.parse(eventEndTime.toDate().toString()));

  String get formattedCreatedTime => DateFormat.yMMMMEEEEd().format(DateTime.parse(createdTime.toDate().toString()));

  factory RegionEventModel.mapToRegionEventModel(QueryDocumentSnapshot<Map<String, dynamic>> event) {
    final users = List<String>.from(event.getOrDefault(eventUsersKey, []));
    return RegionEventModel(
      id: event.id,
      regionAccount: event[regionAccountKey],
      creatorAccount: event[creatorAccountKey],
      eventName: event[eventNameKey],
      eventDescription: event[eventDescriptionKey],
      eventLocation: event[eventLocationKey][geoPointKey],
      eventAddress: event[eventAddressKey],
      eventImage: event[eventImageKey],
      eventStartTime: event[eventStartTimeKey],
      eventEndTime: event[eventEndTimeKey],
      createdTime: event[dateCreatedKey],
      users: users,
    );
  }
}
