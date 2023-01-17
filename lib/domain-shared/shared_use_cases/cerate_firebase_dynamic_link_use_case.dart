import 'package:async/async.dart';
import 'package:hashed/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:hashed/datasource/local/firebase_dynamic_link_service.dart';
import 'package:hashed/domain-shared/app_constants.dart';

class CreateFirebaseDynamicLinkUseCase {
  final FirebaseDynamicLinkService _firebaseDynamicLinkService = FirebaseDynamicLinkService();

  Future<Result<Uri>> createDynamicLink(GuardianRecoveryRequestData data) async {
    final uri = Uri.parse(guardianTargetLink).replace(queryParameters: {
      'lostAccount': data.lostAccount,
      'rescuer': data.rescuer,
      'placeholder': 'guardian',
    });

    print("recover link: $uri");

    return _firebaseDynamicLinkService.createDynamicLinkFromUri(uri);
  }
}
