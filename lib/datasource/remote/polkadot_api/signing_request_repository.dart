import 'dart:convert';
import 'dart:io';

class SigningRequestRepository {
  static const urlScheme = "ssr";
  String jsonToSigningRequestUrl(dynamic json) {
    final string = json.encode(json);
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
}
