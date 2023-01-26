import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:hashed/blocs/deeplink/mappers/deep_link_state_mapper.dart';
import 'package:hashed/blocs/deeplink/mappers/scan_qr_code_state_mapper.dart';
import 'package:hashed/blocs/deeplink/model/deep_link_data.dart';
import 'package:hashed/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:hashed/blocs/deeplink/model/invite_link_data.dart';
import 'package:hashed/blocs/deeplink/usecase/get_initial_deep_link_use_case.dart';
import 'package:hashed/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:hashed/domain-shared/shared_use_cases/get_signing_request_use_case.dart';
import 'package:uni_links/uni_links.dart';

part 'deeplink_event.dart';
part 'deeplink_state.dart';

class DeeplinkBloc extends Bloc<DeeplinkEvent, DeeplinkState> {
  StreamSubscription? _linkStreamSubscription;

  DeeplinkBloc() : super(DeeplinkState.initial()) {
    initDynamicLinks();
    initSigningRequests();
    on<HandleIncomingFirebaseDeepLink>(_handleIncomingFirebaseDeepLink);
    on<HandleIncomingSigningRequest>(_handleIncomingSigningRequest);
    on<OnGuardianRecoveryRequestSeen>((_, emit) => emit(state.copyWith()));
    on<ClearDeepLink>((_, emit) => emit(DeeplinkState.initial()));
  }

  @override
  Future<void> close() {
    _linkStreamSubscription?.cancel();
    return super.close();
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      print("initial link: ${initialLink.link}");
      add(HandleIncomingFirebaseDeepLink(initialLink.link));
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print("received link: ${dynamicLinkData.link}");
      add(HandleIncomingFirebaseDeepLink(dynamicLinkData.link));
    }).onError((error) {
      print("Deep link error: $error");
    });
  }

  Future<void> initSigningRequests() async {
    try {
      final initialLink = await getInitialLink();

      if (initialLink != null) {
        add(HandleIncomingSigningRequest(initialLink));
      }
    } catch (err) {
      print("initial link error: $err");
    }

    _linkStreamSubscription = linkStream.listen((String? uri) {
      if (uri != null) {
        add(HandleIncomingSigningRequest(uri));
      }
    }, onError: (err) {
      print("ESR Error: ${err.toString()}");
    });
  }

  Future<void> _handleIncomingFirebaseDeepLink(
      HandleIncomingFirebaseDeepLink event, Emitter<DeeplinkState> emit) async {
    final DeepLinkData result = await GetInitialDeepLinkUseCase().run(event.newLink);

    emit(DeepLinkStateMapper().mapResultToState(state, result));
  }

  Future<void> _handleIncomingSigningRequest(HandleIncomingSigningRequest event, Emitter<DeeplinkState> emit) async {
    final result = await GetSigningRequestUseCase().run(event.link);
    emit(ScanQRCodeStateMapper().mapSigningRequestToState(state, result));
  }
}
