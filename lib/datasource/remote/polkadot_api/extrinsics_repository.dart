// This code extracted from the SDK
import 'dart:convert';

import 'package:hashed/polkadot/sdk_0.4.8/lib/api/types/txInfoData.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/webViewRunner.dart';

class ExtrinsicsRepository {
  final WebViewRunner _webView;

  ExtrinsicsRepository(this._webView);

  Future<void> sendTransfer({
    required String address,
    required String to,
    required String amount,
  }) async {
    final sender = TxSenderData(
      address,
      "",
    );
    final txInfo = TxInfoData('balances', 'transfer', sender);
    try {
      final hash = await _signAndSend(
        txInfo,
        [
          to,
          amount,
        ],
        onStatusChange: (status) {
          print("onStatusChange: $status");
        },
      );
      print('sendTx ${hash.toString()}');
    } catch (err) {
      print('sendTransfer ERROR $err');
      rethrow;
    }
  }

  Future<String> createRecovery({
    required String address,
    required List<String> guardians,
    required int threshold,
    required int delayPeriod,
  }) async {
    final sender = TxSenderData(
      address,
      "",
    );
    final txInfo = TxInfoData('recovery', 'createRecovery', sender);

    guardians.sort();

    try {
      final hash = await _signAndSend(
        txInfo,
        [
          guardians,
          threshold,
          delayPeriod,
        ],
        onStatusChange: (status) {
          print("onStatusChange: $status");
        },
      );
      print('sendCreateRecovery ${hash.toString()}');
      return hash.toString();
    } catch (err) {
      print('sendCreateRecovery ERROR $err');
      rethrow;
    }
  }

  Future<String?> removeRecovery({required String address}) async {
    final sender = TxSenderData(
      address,
      "",
    );
    final txInfo = TxInfoData('recovery', 'removeRecovery', sender);

    try {
      final hash = await _signAndSend(
        txInfo,
        [],
        onStatusChange: (status) {
          print("onStatusChange: $status");
        },
      );
      print('sendRemoveRecovery ${hash.toString()}');
      return hash.toString();
    } catch (err) {
      print('sendRemoveRecovery ERROR $err');
      rethrow;
    }
  }

  /// Sign and send a transaction
  /// [txInfo] and [params] define the transaction details
  /// [onStatusChange] is a callback when tx status change.
  /// @return txHash [string] if tx finalized success.
  ///
  /// Sign and send is a complex structure that's simplified with this API
  ///
  /// All we need to do is create a TxInfoData object and parameters and we're
  /// good to go
  ///
  /// onStatusChange will be called when the event changes status - is included in a block
  /// or finalized of has an error
  ///
  /// The function returns txHash on success, and throws an error if not successful
  ///
  /// Execution takes block time, meaning around 6 seconds. As it is waiting for the
  /// transaction to be processed.
  ///
  Future<Map<String, dynamic>> _signAndSend(
    TxInfoData txInfo,
    List params, {
    required Function(String) onStatusChange,
  }) async {
    // ignore: prefer_if_null_operators
    final param = jsonEncode(params);
    final Map tx = txInfo.toJson();
    final res = await _serviceSignAndSend(tx, param, onStatusChange);
    if (res['error'] != null) {
      throw Exception(res['error']);
    }
    return res;
  }

  Future<Map<String, dynamic>> _serviceSignAndSend(Map txInfo, String params, Function(String) onStatusChange) async {
    final msgId = "onStatusChange${_webView.getEvalJavascriptUID()}";
    _webView.addMsgHandler(msgId, onStatusChange);
    final code = 'keyring.sendTransaction(api, ${jsonEncode(txInfo)}, $params, "$msgId")';
    print("serviceSignAndSend: $code");
    final dynamic res = await _webView.evalJavascript(code);
    _webView.removeMsgHandler(msgId);
    return res;
  }
}
