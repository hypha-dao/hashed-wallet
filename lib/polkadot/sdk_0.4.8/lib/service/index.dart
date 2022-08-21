import 'dart:async';

import 'package:hashed/polkadot/sdk_0.4.8/lib/service/account.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/assets.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/gov.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/keyring.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/parachain.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/recovery.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/setting.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/staking.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/tx.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/uos.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/walletConnect.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/service/webViewRunner.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/storage/keyring.dart';

/// The service calling JavaScript API of `polkadot-js/api` directly
/// through [WebViewRunner], providing APIs for [PolkawalletApi].
class SubstrateService {
  late ServiceKeyring keyring;
  late ServiceSetting setting;
  late ServiceAccount account;
  late ServiceTx tx;

  late ServiceStaking staking;
  late ServiceGov gov;
  late ServiceParachain parachain;
  late ServiceAssets assets;
  late ServiceUOS uos;
  late ServiceRecovery recovery;

  late ServiceWalletConnect walletConnect;

  WebViewRunner? _web;

  WebViewRunner? get webView => _web;

  Future<void> init({
    Function? onInitiated,
    Function? socketDisconnectedAction,
  }) async {
    keyring = ServiceKeyring(this);
    setting = ServiceSetting(this);
    account = ServiceAccount(this);
    tx = ServiceTx(this);
    staking = ServiceStaking(this);
    gov = ServiceGov(this);
    parachain = ServiceParachain(this);
    assets = ServiceAssets(this);
    uos = ServiceUOS(this);
    recovery = ServiceRecovery(this);

    walletConnect = ServiceWalletConnect(this);

    _web = WebViewRunner();
    await _web!.launch(onInitiated, socketDisconnectedAction: socketDisconnectedAction);
  }
}
