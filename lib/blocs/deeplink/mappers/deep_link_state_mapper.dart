import 'package:hashed/blocs/deeplink/model/deep_link_data.dart';
import 'package:hashed/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:hashed/domain-shared/result_to_state_mapper.dart';

// Example guardian Link: https://joinseeds.com/?placeholder&guardian=esr://gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgA0NBEFdzSW8aAwPDg1W-E3cxMjJAABOUdoMJCPBcMvRdvD7S1NU_2MIsL8itJC_YvSTTODk50M0jOKPcKSjFMsXN0M0xxNDNvDC10tDHLNsvMbjA1Nk8qdAXaAoA
class DeepLinkStateMapper extends StateMapper {
  DeeplinkState mapResultToState(DeeplinkState currentState, DeepLinkData deepLinkData) {
    switch (deepLinkData.deepLinkPlaceHolder) {
      case DeepLinkPlaceHolder.guardian:
        return currentState.copyWith(
          showGuardianApproveOrDenyScreen: (deepLinkData as GuardianDeepLinkData).data,
        );
      case DeepLinkPlaceHolder.unknown:
        // Don't know how to handle this link. Return current state
        return currentState;
    }
  }
}
