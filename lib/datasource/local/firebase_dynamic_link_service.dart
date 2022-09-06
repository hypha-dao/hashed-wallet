import 'package:async/async.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:hashed/domain-shared/app_constants.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class FirebaseDynamicLinkService {
  // guardianTargetLink
  Future<Result<Uri>> createDynamicLink(Uri link) async {
    try {
      final parameters = DynamicLinkParameters(
        uriPrefix: domainAppUriPrefix,
        link: link,
        androidParameters: AndroidParameters(packageName: androidPacakageName),
        iosParameters: IosParameters(bundleId: iosBundleId, appStoreId: iosAppStoreId),
      );

      final Uri dynamicUrl = (await parameters.buildShortLink()).shortUrl;

      return Result.value(dynamicUrl);
    } catch (error) {
      print("Error creating dynamic link $error");
      return Result.error(error);
    }
  }
}
