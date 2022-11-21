import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:hashed/datasource/remote/model/substrate_chain_container.dart';
import 'package:hashed/datasource/remote/model/substrate_chain_model.dart';
import 'package:hashed/domain-shared/firebase_constants.dart';

class ChainsRepository {
  ChainsRepository();

  Future<String> loadAsset() async {
    return rootBundle.loadString('assets/polkadot/default_endpoints.json');
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
      final jsonString = await loadAsset();
      final List<dynamic> json = jsonDecode(jsonString);

      //print("get chains: $json");

      return [];

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
}
