// @dart=2.9
import 'package:seeds/datasource/local/flutter_js/app_code/lib/app.dart';
import 'package:seeds/datasource/local/flutter_js/app_code/lib/common/consts.dart';
import 'package:package_info/package_info.dart';

class Utils {
  static Future<int> getBuildNumber() async {
    return int.tryParse((await PackageInfo.fromPlatform()).buildNumber);
  }

  static Future<String> getAppVersion() async {
    return "${(await PackageInfo.fromPlatform()).version}-${WalletApp.buildTarget == BuildTargets.dev ? "dev" : "beta"}.${(await PackageInfo.fromPlatform()).buildNumber.substring((await PackageInfo.fromPlatform()).buildNumber.length - 1)}";
  }

  static String currencySymbol(String priceCurrency) {
    switch (priceCurrency) {
      case "USD":
        return "\$";
      case "CNY":
        return "￥";
      default:
        return "\$";
    }
  }
}
