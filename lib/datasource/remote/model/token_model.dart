import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TokenModel extends Equatable {
  static List<TokenModel> allTokens = [hashedToken];

  final String chainName;
  final String symbol;
  final String name;
  final String backgroundImageUrl;
  final String logoUrl;
  final int precision;
  final String id;

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
    required this.symbol,
    required this.name,
    required this.backgroundImageUrl,
    required this.logoUrl,
    required this.id,
    this.precision = 8,
  });

  factory TokenModel.fromId(String tokenId) {
    return allTokens.firstWhere((e) => e.id == tokenId);
  }

  static TokenModel? fromSymbolOrNull(String symbol) {
    return allTokens.firstWhereOrNull((e) => e.symbol == symbol);
  }

  @override
  List<Object?> get props => [chainName, symbol];

  String getAssetString(double quantity) {
    return "${quantity.toStringAsFixed(precision)} $symbol";
  }
}

const hashedToken = TokenModel(
  id: "HashedTokenMainHSD",
  chainName: "Hashed Chain (Demo)",
  symbol: "HSD",
  name: "Hashed Token",
  // ignore: avoid_redundant_argument_values
  precision: 12,
  backgroundImageUrl: 'assets/images/wallet/currency_info_cards/hashed/background.png',
  logoUrl: 'assets/images/hashed_logo_black.png',
);
