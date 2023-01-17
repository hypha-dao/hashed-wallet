import 'package:async/async.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:hashed/domain-shared/app_constants.dart';
import 'package:hashed/domain-shared/base_use_case.dart';

class FirebaseDynamicLinkService {
  // guardianTargetLink
  Future<Result<Uri>> createDynamicLinkFromUri(Uri link) async {
    try {
      final parameters = DynamicLinkParameters(
        uriPrefix: domainAppUriPrefix,
        link: link,
        androidParameters: const AndroidParameters(packageName: androidPacakageName),
        iosParameters: const IOSParameters(bundleId: iosBundleId, appStoreId: iosAppStoreId),
      );

      final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);

      return Result.value(dynamicLink.shortUrl);
    } catch (error) {
      print("Error creating dynamic link $error");
      return Result.error(error);
    }
  }
}
