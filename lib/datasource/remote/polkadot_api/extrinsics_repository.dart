// This code extracted from the SDK
import 'dart:convert';

import 'package:hashed/datasource/local/flutter_js/web_view_runner.dart';
import 'package:hashed/datasource/local/models/substrate_transaction_model.dart';

//! ### Recovery Life Cycle
//!
//! The intended life cycle of a successful recovery takes the following steps:
//! 1. The account owner calls `create_recovery` to set up a recovery configuration
//!    for their account.
//! 2. At some later time, the account owner loses access to their account and wants
//!    to recover it. Likely, they will need to create a new account and fund it with
//!    enough balance to support the transaction fees and the deposit for the
//!    recovery process.
//! 3. Using this new account, they call `initiate_recovery`.
//! 4. Then the account owner would contact their configured friends to vouch for
//!    the recovery attempt. The account owner would provide their old account id
//!    and the new account id, and friends would call `vouch_recovery` with those
//!    parameters.
//! 5. Once a threshold number of friends have vouched for the recovery attempt,
//!    the account owner needs to wait until the delay period has passed, starting
//!    when they initiated the recovery process.
//! 6. Now the account owner is able to call `claim_recovery`, which subsequently
//!    allows them to call `as_recovered` and directly make calls on-behalf-of the lost
//!    account.
//! 7. Using the now recovered account, the account owner can call `close_recovery`
//!    on the recovery process they opened, reclaiming the recovery deposit they
//!    placed.
//! 8. Then the account owner should then call `remove_recovery` to remove the recovery
//!    configuration on the recovered account and reclaim the recovery configuration
//!    deposit they placed.
//! 9. Using `as_recovered`, the account owner is able to call any other pallets
//!    to clean up their state and reclaim any reserved or locked funds. They
//!    can then transfer all funds from the recovered account to the new account.
//! 10. When the recovered account becomes reaped (i.e. its free and reserved
//!     balance drops to zero), the final recovery link is removed.
//!
//! Side-note: We can also call cancel_recovery to remove a user's ability to make
//! transactions on behalf of the recovered account.
//!
//! ### Malicious Recovery Attempts
//!
//! Initializing a the recovery process for a recoverable account is open and
//! permissionless. However, the recovery deposit is an economic deterrent that
//! should disincentivize would-be attackers from trying to maliciously recover
//! accounts.
//!
//! The recovery deposit can always be claimed by the account which is trying to
//! to be recovered. In the case of a malicious recovery attempt, the account
//! owner who still has access to their account can claim the deposit and
//! essentially punish the malicious user.
//!
//! Note: The account can call "close_recovery" to stop the malicious attempt and claim
//! the deposit the attacker put in. The account should also call remove_recovery in case
//! one or more of their friends were tricked into signing the recovery.
//! There's a configurable delay - example 24 hours - and during that time, the
//! account owner can call close_recovery and remove_recovery.
//!
//! I think it should be like this:
//! Malicious recovery with no signatures - call close
//! Malicious recovery with signatures - call close and remove
//! The app will make that decision for the user.
//!
//! We cannot prevent anyone from making a malicious attempt - they only need to pay the
//! fee. So we close and claim the fee, but our guardians were not compromised.
//!
//! In case some guardians signed, we close and remove, so our account remains safe.
//! We then need to choose new guardians.
//!
//! Furthermore, the malicious recovery attempt can only be successful if the
//! attacker is also able to get enough friends to vouch for the recovery attempt.
//! In the case where the account owner prevents a malicious recovery process,
//! this pallet makes it near-zero cost to re-configure the recovery settings and
//! remove/replace friends who are acting inappropriately.

abstract class ExtrinsicsRepository {
  final WebViewRunner _webView;

  ExtrinsicsRepository(this._webView);

  Future<dynamic> evalJavascript(String code) {
    return _webView.evalJavascript(code);
  }

  Future<dynamic> evalJavascriptRaw(String code) {
    return _webView.evalJavascript(code, wrapPromise: false);
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
  Future<Map<String, dynamic>> signAndSend(
    SubstrateTransactionModel txInfo,
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
