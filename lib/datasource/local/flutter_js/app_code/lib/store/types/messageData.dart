import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:polkawallet_plugin_chainx/common/components/UI.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/service/walletApi.dart';

part 'messageData.g.dart';

@JsonSerializable()
class MessageData {
  MessageData(this.file, this.banner, this.time, this.title, this.network, this.lang, this.content);
  String file;
  String banner;
  String title;
  DateTime time;
  String network;
  String lang;
  String content;

  void onDetailAction(BuildContext context) {
    UI.launchURL("${WalletApi.vercelEndpoint}/posts/${Uri.encodeComponent(this.file)}");
  }

  String urlByBanner() {
    return "${WalletApi.vercelEndpoint}${this.banner}";
  }

  factory MessageData.fromJson(Map<String, dynamic> json) => _$MessageDataFromJson(json);
  Map<String, dynamic> toJson() => _$MessageDataToJson(this);
}
