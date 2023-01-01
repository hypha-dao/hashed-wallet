import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hashed/datasource/local/models/substrate_extrinsic_model.dart';
import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';
import 'package:hashed/datasource/remote/polkadot_api/signing_request_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // final recovered = '5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym';
  final guardians = [
    '5GEbpz29EkSM3vKtzuUEXtwpK8vguYm2TRRsmekQufYJDJpz',
    '5Da6BeYLC3BRvS2H3bQ6JWgMGZtqKGdaoKMPhdtYMf56VaCU',
    '5EUqh98iKNwWQjpzYQPVw3LEQiiaVMaB4Yp2ugXA5fMKFDLk'
  ];
  final rescuer = '5G6XUFXZsdUYdB84eEjvPP33tFF1DjbSg7MPsNAx3mVDnxaW';

  group('json code and decode', () {
    test('encode and decode json', () async {
      final repo = SigningRequestRepository();

      /// Note on this test - we use a transaction model Json for our test
      /// but note that the ssr is going to be an ssr object. For this test,
      /// we just want to know the json encoding and decoding is working.
      final sender = TxSenderData(rescuer);
      final txInfo = SubstrateExtrinsicModel(module: 'recovery', call: 'createRecovery', sender: sender);
      final guardianAddresses = guardians;
      guardianAddresses.sort();
      final params = [guardianAddresses, 2, 3000];
      final transactionModel = SubstrateTransactionModel(extrinsic: txInfo, parameters: params);
      final json = transactionModel.toJson();
      print("json 1: $json");

      final originalJsonString = jsonEncode(json);

      final ssrUrl = repo.jsonToSigningRequestUrl(json);

      print("url: $ssrUrl");

      final jsonFromUrl = repo.signingRequestUrlToJson(ssrUrl);

      print("json 2 $jsonFromUrl");

      final decodedJsonString = jsonEncode(jsonFromUrl);

      expect(originalJsonString, decodedJsonString);
    });
  });
}
