import 'package:hashed/blocs/deeplink/model/guardian_recovery_request_data.dart';

class DeepLinkData {
  final DeepLinkPlaceHolder deepLinkPlaceHolder;

  const DeepLinkData(this.deepLinkPlaceHolder);
}

enum DeepLinkPlaceHolder { guardian, unknown }

class GuardianDeepLinkData extends DeepLinkData {
  GuardianRecoveryRequestData data;

  GuardianDeepLinkData(this.data, super.deepLinkPlaceHolder);
}
