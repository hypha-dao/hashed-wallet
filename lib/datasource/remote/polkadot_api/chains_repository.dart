import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:hashed/datasource/remote/model/substrate_chain_container.dart';
import 'package:hashed/datasource/remote/model/substrate_chain_model.dart';
import 'package:hashed/domain-shared/firebase_constants.dart';

class ChainsRepository {
  List<String>? cachedLogoInfo;
  ChainsRepository();

  Future<String> loadLocalEndpointData() async {
    return rootBundle.loadString('assets/polkadot/default_endpoints.json');
  }

  Future<List<String>> loadLogoPaths() async {
    final text = await rootBundle.loadString('assets/polkadot/assets_info.txt');
    print("parse file for paths");
    RegExp exp = RegExp("import [a-zA-Z0-9]+ from '(.*)';");
    final matches = exp.allMatches(text);
    // matches.forEach(
    //   // ignore: avoid_print, prefer_interpolation_to_compose_strings
    //   (element) => print("match group 1: " + (element.group(1) ?? "")),
    // );
    return List.from(matches.map((e) => e.group(1)));
  }

  Future<List<String>> loadLogoInfo() async {
    final text = await rootBundle.loadString('assets/polkadot/logo_info.json');
    List<dynamic> map = jsonDecode(text);
    
    print("parse file for paths");
    RegExp exp = RegExp("import [a-zA-Z0-9]+ from '(.*)';");
    final matches = exp.allMatches(text);
    // matches.forEach(
    //   // ignore: avoid_print, prefer_interpolation_to_compose_strings
    //   (element) => print("match group 1: " + (element.group(1) ?? "")),
    // );
    return List.from(matches.map((e) => e.group(1)));
  }

  Future<String> resolveIcon(String info) async {
    // TODO(NIK): This is still not really working - fix and remove prints
    cachedLogoInfo ??= await loadLogoPaths();
    print("looking for $info");
    final index = cachedLogoInfo!.indexOf("/$info.");
    if (index == -1) {
      print("error: logo not found: $info");
      return "";
    }

    print("resolve icon: $res ");
    return res;
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

      print("get chains: $json");

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
