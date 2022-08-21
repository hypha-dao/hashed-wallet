import 'package:hashed/polkadot/sdk_0.4.8/lib/api/types/parachain/bidData.dart';
import 'package:hashed/polkadot/sdk_0.4.8/lib/api/types/parachain/fundData.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auctionData.g.dart';

@JsonSerializable(explicitToJson: true)
class AuctionData extends _AuctionData {
  static AuctionData fromJson(Map json) => _$AuctionDataFromJson(json as Map<String, dynamic>);
  Map toJson() => _$AuctionDataToJson(this);
}

abstract class _AuctionData {
  AuctionOverview auction = AuctionOverview();
  List<FundData> funds = [];
  List<BidData> winners = [];
}

@JsonSerializable()
class AuctionOverview extends _AuctionOverview {
  static AuctionOverview fromJson(Map json) => _$AuctionOverviewFromJson(json as Map<String, dynamic>);
  Map toJson() => _$AuctionOverviewToJson(this);
}

abstract class _AuctionOverview {
  String? bestNumber;
  String? endBlock;
  int? numAuctions;
  int? leasePeriod;
  int? leaseEnd;
}
