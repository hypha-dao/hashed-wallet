// @dart=2.9
import 'package:seeds/datasource/local/flutter_js/app_code/lib/store/account.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/store/assets.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/store/parachain.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/store/settings.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobx/mobx.dart';

class AppStore {
  AppStore(this.storage);

  final GetStorage storage;

  AccountStore account;
  SettingsStore settings;
  AssetsStore assets;
  ParachainStore parachain;

  @action
  Future<void> init() async {
    settings = SettingsStore(storage);
    await settings.init();
    account = AccountStore();
    assets = AssetsStore(storage);
    parachain = ParachainStore();
  }
}
