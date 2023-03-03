import 'dart:convert';
import 'dart:io';

import 'package:hashed/datasource/local/models/substrate_signing_request_model.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/utils/result_extension.dart';

class SigningRequestRepository {
  static const urlScheme = "ssr";

  String jsonToSigningRequestUrl(dynamic jsonObj) {
    final string = json.encode(jsonObj);
    final bytes = utf8.encode(string);
    final zippedBytes = gzip.encode(bytes);
    final base64url = base64Url.encode(zippedBytes);
    return "$urlScheme://$base64url";
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
      print(err);
      print(s);
      return null;
    }
  }

  Result<String> toUrl(SubstrateSigningRequestModel signingRequest) {
    try {
      return Result.value(jsonToSigningRequestUrl(signingRequest.toJson()));
    } catch (error, s) {
      print("error encoding signing request $error");
      print(s);
      return Result.error(error);
    }
  }

  Future<Result<Map<String, dynamic>>> signAndSendSigningRequest(
      SubstrateSigningRequestModel signingRequestModel, String senderAddress) async {
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
    final extrinsicModel = transaction.extrinsic.resolvePlaceholders(senderAddress);
    final params = transaction.parameters;

    try {
      final res =
          await polkadotRepository.balancesRepository.signAndSend(extrinsicModel, params, onStatusChange: (status) {
        print("send onStatusChange: $status");
      });

      return Result.value(res);
    } catch (err) {
      print("error signing request: $err");
      return Result.error(err);
    }
  }
}
