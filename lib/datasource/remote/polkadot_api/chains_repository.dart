import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/model/substrate_chain_container.dart';
import 'package:hashed/datasource/remote/model/substrate_chain_model.dart';
import 'package:hashed/domain-shared/app_constants.dart';
import 'package:hashed/domain-shared/firebase_constants.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/viewdata/network_data.dart';

final polkadotJSGithubRawURLPrefix =
    "https://raw.githubusercontent.com/polkadot-js/apps/master/packages/apps-config/src/ui/logos";

ChainsRepository chainsRepository = ChainsRepository();

class ChainsRepository {
  List<NetworkDataListItem>? networksCache;
  List<String>? cachedLogoPaths;
  Map<String, dynamic>? cachedLogoInfo;

  ChainsRepository();

  Future<String> loadLocalEndpointData() async {
    return rootBundle.loadString('assets/polkadot/default_endpoints.json');
  }

  Future<List<String>> loadLogoPaths() async {
    final text = await rootBundle.loadString('assets/polkadot/assets_info.txt');

    /// This reg exp extracts only the file path from this entire file
    /// maps "import bla from '/img/path/foo.png'" ===> "/img/path/foo.png"
    final exp = RegExp("import [a-zA-Z0-9]+ from '.(.*)';");
    final matches = exp.allMatches(text);
    return List.from(matches.map((e) => e.group(1)));
  }

  /// Parse a file that maps chains to image files
  Future<Map<String, dynamic>> loadLogoInfo() async {
    final text = await rootBundle.loadString('assets/polkadot/logo_info.json');
    final Map<String, dynamic> map = jsonDecode(text);
    return map;
  }

  /// Resolve "info" string from a chain to an icon
  /// For this we use the information provided by polkadot js
  /// There's a mapping of chain names -> images and another one that contains
  /// image paths.
  Future<String> resolveIcon(String info) async {
    cachedLogoPaths ??= await loadLogoPaths();
    cachedLogoInfo ??= await loadLogoInfo();
    final String? imageName = cachedLogoInfo![info];

    if (imageName == null) {
      print("not founds: $info");
      return "";
    }
    final String? path = cachedLogoPaths!.firstWhereOrNull((e) => e.contains(imageName));
    if (path == null) {
      print("error: logo not found: $info  $imageName");
      return "";
    }
    final prefix = polkadotJSGithubRawURLPrefix;
    // print("resolve $info ==> ${prefix + path} ");
    return prefix + path;
  }

  List<SubstrateChainModel> getChains() {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      final jsonString = remoteConfig.getString(chainInfoSettingsFirebaseKey);
      final List<dynamic> json = jsonDecode(jsonString);

      print("get chains:$json");
      return json.map((e) => SubstrateChainModel.fromJson(e)) as List<SubstrateChainModel>;
    } catch (err) {
      print("error $err");
      rethrow;
    }
  }

  Future<List<SubstrateChainContainer>> getChainsLocal() async {
    try {
      final jsonString = await loadLocalEndpointData();
      final List<dynamic> json = jsonDecode(jsonString);

      return List.of(json.map((e) => SubstrateChainContainer.fromJson(e)));
    } catch (err) {
      print("error $err");
      rethrow;
    }
  }

  // The production chains we always show
  Future<List<SubstrateChainContainer>> getMainChains() async {
    final list = await getChainsLocal();
    return list.where((e) => e.header.toLowerCase() == "polkadot" || e.header.toLowerCase() == "kusama").toList();
  }

  // dev chains for the developer's convenience
  Future<List<SubstrateChainContainer>> getDevChains() async {
    final list = await getChainsLocal();
    return list.where((e) => e.header.toLowerCase() != "polkadot" && e.header.toLowerCase() != "kusama").toList();
  }

  Future<List<NetworkDataListItem>> getNetworks({bool devMode = false}) async {
    if (networksCache == null) {
      final chainData = await getChainsLocal();

      final List<NetworkDataListItem> list = [];

      /// Add Hashed Chain
      list.add(NetworkDataHeader("Hashed"));
      list.add(hashedNetworkData);

      /// Add Polkadot, Kusama, and dev chains
      for (final chainContainer in chainData) {
        if (!devMode) {
          final name = chainContainer.header.toLowerCase();
          if (!chainContainer.isRelayChain || (name != "polkadot" && name != "kusama")) {
            continue;
          }
        }

        list.add(NetworkDataHeader(chainContainer.header));

        if (chainContainer.isRelayChain) {
          final chain = chainContainer.relayChain!;
          final icon = await resolveIcon(chain.info);
          list.add(chain.toNetworkData(icon));

          for (final paraChain in chain.linked ?? []) {
            final icon = await resolveIcon(paraChain.info);
            list.add(paraChain.toNetworkData(icon));
          }
        } else {
          for (final devChain in chainContainer.list ?? []) {
            final icon = await resolveIcon(devChain.info);
            list.add(devChain.toNetworkData(icon));
          }
        }
      }
      networksCache = list;
    }

    return networksCache!;
  }

  Future<NetworkData> currentNetwork() async {
    return getNetworkByinfo(settingsStorage.currentNetwork);
  }

  Future<NetworkData> getNetworkByinfo(String info) async {
    final networks = await getNetworks();
    final res = networks.firstWhere(
      (e) => e is NetworkData && e.info == info,
      orElse: () => hashedNetworkData,
    );
    return res as NetworkData;
  }

  final hashedNetworkData = const NetworkData(
    name: 'Hashed Network',
    info: hashedNetworkId,
    iconUrl: 'assets/images/appbar/hashed_logo.png',
    endpoints: ['wss://n1.hashed.systems'],
  );
}
