import 'dart:convert';
import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:seeds/datasource/remote/api/tokenmodels_repository.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_token_models_use_case.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/components/currency_info_card.dart';

class TokenModel extends Equatable {
  static const seedsEcosysUsecase = 'seedsecosys';
  static List<TokenModel> allTokens = [seedsToken];
  static JsonSchema? tmastrSchema;
  final String chainName;
  final String contract;
  final String symbol;
  final String name;
  final String backgroundImageUrl;
  final String logoUrl;
  final String balanceSubTitle;
  final int precision;
  final List<String>? usecases;

  String get id => "$contract#$symbol";

  ImageProvider get backgroundImage {
    return backgroundImageUrl.startsWith("assets")
        ? AssetImage(backgroundImageUrl) as ImageProvider
        : NetworkImage(backgroundImageUrl);
  }

  ImageProvider get logo {
    return logoUrl.startsWith("assets") ? AssetImage(logoUrl) as ImageProvider : NetworkImage(logoUrl);
  }

  const TokenModel({
    required this.chainName,
    required this.contract,
    required this.symbol,
    required this.name,
    required this.backgroundImageUrl,
    required this.logoUrl,
    required this.balanceSubTitle,
    this.precision = 4,
    this.usecases,
  });

  static Future<Result<void>> installSchema() async {
    final result = await TokenModelsRepository().getSchema();
    if (result.isValue) {
      final tmastrSchemaMap = result.asValue!.value;
      tmastrSchema = JsonSchema.createSchema(tmastrSchemaMap);
      return Result.value(null);
    }
    print('Error getting Token Master schema from chain');
    return result;
  }

  static TokenModel? fromJson(Map<String, dynamic> data) {
    final Map<String, dynamic> parsedJson = json.decode(data["json"]);
    bool extendJson(String dataField, String jsonField) {
      final jsonData = parsedJson[jsonField];
      if (jsonData != null && jsonData != data[dataField]) {
        print('${data[dataField]}: mismatched $dataField in json'
            ' $jsonData, ${data[dataField]}');
        return false;
      } else {
        parsedJson[jsonField] ??= data[dataField];
        return true;
      }
    }

    if (!(extendJson("chainName", "chain") &&
        extendJson("contract", "account") &&
        extendJson("symbolcode", "symbol") &&
        extendJson("usecases", "usecases"))) {
      return null;
    }
    if (tmastrSchema == null) {
      return null;
    }
    final validationErrors = tmastrSchema!.validateWithErrors(parsedJson);
    if (validationErrors.isNotEmpty) {
      print('${data["symbolcode"]}:\t${validationErrors.map((e) => e.toString())}');
      return null;
    }
    return TokenModel(
      chainName: parsedJson["chain"]!,
      contract: parsedJson["account"]!,
      symbol: parsedJson["symbol"]!,
      name: parsedJson["name"]!,
      logoUrl: parsedJson["logo"]!,
      balanceSubTitle: parsedJson["subtitle"],
      backgroundImageUrl: parsedJson["bg_image"] ?? CurrencyInfoCard.defaultBgImage,
      precision: parsedJson["precision"] ?? 4,
      usecases: parsedJson["usecases"],
    );
  }

  factory TokenModel.fromId(String tokenId) {
    return allTokens.firstWhere((e) => e.id == tokenId);
  }

  static TokenModel? fromSymbolOrNull(String symbol) {
    return allTokens.firstWhereOrNull((e) => e.symbol == symbol);
  }

  @override
  List<Object?> get props => [chainName, contract, symbol];

  String getAssetString(double quantity) {
    return "${quantity.toStringAsFixed(precision)} $symbol";
  }

  static Future<void> updateModels(List<String> acceptList, [List<String>? infoList]) async {
    final selector = TokenModelSelector(acceptList: acceptList, infoList: infoList);
    final tokenListResult = await GetTokenModelsUseCase().run(selector);
    if (tokenListResult.isError) {
      return;
    }
    final tokenList = tokenListResult.asValue!.value;
    for (final newtoken in tokenList) {
      allTokens.removeWhere((token) =>
          token.contract == newtoken.contract &&
          token.chainName == newtoken.chainName &&
          token.symbol == newtoken.symbol);
    }
    allTokens.addAll(tokenList);
  }

  static Future<void> installModels(List<String> acceptList, [List<String>? infoList]) async {
    // if( remoteConfigurations.featureFlagTokenMasterListEnabled) {
    //   final installResult = await installSchema();
    //   if(installResult.isValue) {
    //     allTokens = [seedsToken];
    //     await updateModels(acceptList, infoList);
    //     return;
    //   }
    // }
    allTokens = _staticTokenList;
  }

  static void pruneRemoving(List<String> useCaseList) {
    allTokens.removeWhere((token) => token.usecases?.any((uc) => useCaseList.contains(uc)) ?? false);
  }

  static void pruneKeeping(List<String> useCaseList) {
    allTokens.removeWhere((token) => !(token.usecases?.any((uc) => useCaseList.contains(uc)) ?? false));
  }
}

const seedsToken = TokenModel(
  chainName: "Telos",
  contract: "token.seeds",
  symbol: "SEEDS",
  name: "Seeds",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/seeds/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/seeds/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  usecases: ["lightwallet", TokenModel.seedsEcosysUsecase],
);

final _staticTokenList = [seedsToken, _husdToken, _hyphaToken, _localScaleToken, _starsToken, _telosToken, _hashed];
const _husdToken = TokenModel(
  chainName: "Telos",
  contract: "husd.hypha",
  symbol: "HUSD",
  name: "HUSD",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/husd/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/husd/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  precision: 2,
  usecases: ["lightwallet", TokenModel.seedsEcosysUsecase],
);

const _hyphaToken = TokenModel(
  chainName: "Telos",
  contract: "hypha.hypha",
  symbol: "HYPHA",
  name: "Hypha",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/hypha/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/hypha/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  precision: 2,
  usecases: ["lightwallet", TokenModel.seedsEcosysUsecase],
);

const _localScaleToken = TokenModel(
  chainName: "Telos",
  contract: "token.local",
  symbol: "LSCL",
  name: "LocalScale",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/lscl/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/lscl/logo.png',
  balanceSubTitle: 'Wallet Balance',
  usecases: ["lightwallet"],
);

const _starsToken = TokenModel(
  chainName: "Telos",
  contract: "star.seeds",
  symbol: "STARS",
  name: "Stars",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/stars/background.jpg',
  logoUrl: 'assets/images/wallet/currency_info_cards/stars/logo.jpg',
  balanceSubTitle: 'Wallet Balance',
  usecases: ["lightwallet"],
);

const _telosToken = TokenModel(
  chainName: "Telos",
  contract: "eosio.token",
  symbol: "TLOS",
  name: "Telos",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/tlos/background.png',
  logoUrl: 'assets/images/wallet/currency_info_cards/tlos/logo.png',
  balanceSubTitle: 'Wallet Balance',
  usecases: ["lightwallet"],
);

const _hashed = TokenModel(
  chainName: "Hashed",
  contract: "hashed.token",
  symbol: "Hashed",
  name: "Hashed",
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/hashed/background.png',
  logoUrl: 'assets/images/wallet/currency_info_cards/hashed/logo.png',
  balanceSubTitle: 'Wallet Balance',
  usecases: ["lightwallet"],
);