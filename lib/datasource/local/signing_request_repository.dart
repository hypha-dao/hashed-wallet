import 'dart:convert';
import 'dart:io';

import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/models/substrate_signing_request_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';

class SigningRequestRepository {
  static const urlScheme = "ssr";

  String jsonToSigningRequestUrl(dynamic jsonObj) {
    final string = json.encode(jsonObj);
    final bytes = utf8.encode(string);
    final zippedBytes = gzip.encode(bytes);
    final base64url = base64Url.encode(zippedBytes);

    return "$urlScheme://$base64url";

    // var decoded = json.decode('["foo", { "bar": 499 }]');
  }

  /// returns JSON object
  dynamic signingRequestUrlToJson(String url) {
    final urlComponents = url.split("://");
    if (urlComponents.length == 2) {
      if (urlComponents[0] == urlScheme) {
        final payload = urlComponents[1];
        final zippedBytes = base64Url.decode(payload);
        final bytes = gzip.decode(zippedBytes);
        final string = utf8.decode(bytes);
        final result = json.decode(string);
        return result;
      } else {
        throw "Unsupported URL scheme: ${urlComponents[0]}";
      }
    } else {
      throw "Invalid URL: $url";
    }
  }

  SubstrateSigningRequestModel? parseUrl(String url) {
    try {
      final Map<String, dynamic> ssrJson = signingRequestUrlToJson(url);
      return SubstrateSigningRequestModel.fromJson(ssrJson);
    } catch (err, s) {
      print("Unable to parse signing request URL: $url");
      print(err.toString());
      print(s);
      return null;
    }
  }

  String toUrl(SubstrateSigningRequestModel signingRequest) {
    return jsonToSigningRequestUrl(signingRequest.toJson());
  }

  Future<Map<String, dynamic>> signAndSendSigningRequest(SubstrateSigningRequestModel signingRequestModel) async {
    // check chain
    if (signingRequestModel.chainId != settingsStorage.currentNetwork) {
      throw "Wrong chain - switch to the chain ${signingRequestModel.chainId} before signing this request.";
    }
    // check transactions
    if (signingRequestModel.transactions.isEmpty) {
      throw "Invalid request - need at least one transaction";
    }
    if (signingRequestModel.transactions.length > 1) {
      throw "Invalid request - currently limited to 1 transaction";
    }
    final transaction = signingRequestModel.transactions[0];

    // resolve sender
    final extrinsicModel = transaction.extrinsic.resolvePlaceholders(accountService.currentAccount.address);
    final params = transaction.parameters;

    final res =
        await polkadotRepository.balancesRepository.signAndSend(extrinsicModel, params, onStatusChange: (status) {
      print("send onStatusChange: $status");
    });

    return res;
  }
}
