import 'package:equatable/equatable.dart';

class FirebaseUserModel extends Equatable {
  final String account;

  const FirebaseUserModel({required this.account});

  // ignore: avoid_unused_constructor_parameters
  factory FirebaseUserModel.fromDocument(Map<String, dynamic> document, String account) {
    return FirebaseUserModel(
      account: account,
    );
  }

  @override
  List<Object?> get props => [account];
}
