import 'package:hashed/blocs/deeplink/model/deep_link_data.dart';
import 'package:hashed/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:hashed/domain-shared/shared_use_cases/get_signing_request_use_case.dart';

class GetInitialDeepLinkUseCase {
  GetSigningRequestUseCase getSigningRequestUseCase = GetSigningRequestUseCase();

  Future<DeepLinkData> run(Uri newLink) async {
    print("handling link $newLink");

    final placeHolder = newLink.queryParameters["placeholder"];

    print("handling placeHolder $placeHolder");

    final deepLinkPlaceHolder = DeepLinkPlaceHolder.values
        .singleWhere((i) => placeHolder?.contains(i.name) ?? false, orElse: () => DeepLinkPlaceHolder.unknown);

    switch (deepLinkPlaceHolder) {
      case DeepLinkPlaceHolder.guardian:
        final rescuer = newLink.queryParameters["rescuer"];
        final lostAccount = newLink.queryParameters["lostAccount"];
        if (rescuer != null && lostAccount != null) {
          final data = GuardianRecoveryRequestData(rescuer: rescuer, lostAccount: lostAccount);
          return GuardianDeepLinkData(data, deepLinkPlaceHolder);
        } else {
          return DeepLinkData(deepLinkPlaceHolder);
        }
      case DeepLinkPlaceHolder.unknown:
        return DeepLinkData(deepLinkPlaceHolder);
    }
  }
}
