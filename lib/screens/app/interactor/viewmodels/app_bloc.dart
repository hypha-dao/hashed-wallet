import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:hashed/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:hashed/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/app/interactor/viewmodels/app_page_commands.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final DeeplinkBloc _deeplinkBloc;

  AppBloc(this._deeplinkBloc) : super(AppState.initial(_deeplinkBloc.state.guardianRecoveryRequestData)) {
    _deeplinkBloc.stream.listen((state) {
      if (state.guardianRecoveryRequestData != null) {
        add(OnApproveGuardianRecoveryDeepLink(state.guardianRecoveryRequestData!));
      } else if (state.signingRequest != null) {
        add(OnSigningRequest(state.signingRequest!));
      }
    });

    on<OnAppMounted>(_onAppMounted);
    on<ShouldShowNotificationBadge>(_shouldShowNotificationBadge);
    on<BottomBarTapped>(_bottomBarTapped);
    on<ShouldShowGuardianRecoveryAlert>(_shouldShowGuardianRecoveryAlert);
    on<OnStopGuardianActiveRecoveryTapped>(_onStopGuardianActiveRecovery);
    on<ClearAppPageCommand>(_clearAppPageCommand);
    on<OnDismissGuardianRecoveryTapped>(_onDismissGuardianRecoveryTapped);
    on<OnApproveGuardianRecoveryTapped>(_onApproveGuardianRecoveryTapped);
    on<OnApproveGuardianRecoveryDeepLink>(_onApproveGuardianRecoveryDeepLink);
    on<OnSigningRequest>(_onSigningRequest);
  }

  @override
  Future<void> close() {
    // _hasGuardianNotificationPending.cancel();
    // _shouldShowCancelGuardianAlertMessage.cancel();
    return super.close();
  }

  Future<void> _onAppMounted(OnAppMounted event, Emitter<AppState> emit) async {
    // The first time app widged is mounted, check if there is a signing request waiting.
    if (_deeplinkBloc.state.signingRequest != null) {
      // When user clicks a signing deeplink
      // Android S.O. creates a new app instance and starts from launch
      // even if there is already one open, so we need catch that link
      // when app widget is mounted for first time.
      add(OnSigningRequest(_deeplinkBloc.state.signingRequest!));
      // keep show loading during transition to confirm transaction
      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(pageState: PageState.initial));
    } else {
      emit(state.copyWith(pageState: PageState.initial));
    }
  }

  void _shouldShowNotificationBadge(ShouldShowNotificationBadge event, Emitter<AppState> emit) {
    emit(state.copyWith(
      hasNotification: event.value,
      showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen,
    ));
  }

  void _bottomBarTapped(BottomBarTapped event, Emitter<AppState> emit) {
    emit(state.copyWith(
      index: event.index,
      pageCommand: BottomBarNavigateToIndex(event.index),
      showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen,
    ));
  }

  void _shouldShowGuardianRecoveryAlert(ShouldShowGuardianRecoveryAlert event, Emitter<AppState> emit) {
    emit(state.copyWith(
      showGuardianRecoveryAlert: event.showGuardianRecoveryAlert,
      showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen,
    ));
  }

  Future<void> _onStopGuardianActiveRecovery(OnStopGuardianActiveRecoveryTapped event, Emitter<AppState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    // TBD - delete this code
    // final result = await StopGuardianRecoveryUseCase().run();
    // emit(StopGuardianRecoveryStateMapper().mapResultToState(state, result));
  }

  void _clearAppPageCommand(ClearAppPageCommand event, Emitter<AppState> emit) {
    emit(state.copyWith(showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen));
  }

  void _onDismissGuardianRecoveryTapped(OnDismissGuardianRecoveryTapped event, Emitter<AppState> emit) {
    // Update Deep Link Bloc State
    _deeplinkBloc.add(const OnGuardianRecoveryRequestSeen());
    emit(state.copyWith());
  }

  Future<void> _onApproveGuardianRecoveryTapped(OnApproveGuardianRecoveryTapped event, Emitter<AppState> emit) async {
    // Update Deep Link Bloc State
    _deeplinkBloc.add(const OnGuardianRecoveryRequestSeen());
    emit(state.copyWith(pageState: PageState.loading));

    /// this should simply take the data - lostAccount and rescuer - and vouch.
    ///

    print("recovery vouch: ${event.data.rescuer} lost: ${event.data.lostAccount}");
    print("Not yet implemented");

    throw UnimplementedError("implement this or remove.");

    // final result = await ApproveGuardianRecoveryUseCase()
    //     .approveGuardianRecovery(lostAccount: event.data.lostAccount, rescuer: event.data.rescuer);
    // emit(ApproveGuardianRecoveryStateMapper().mapResultToState(state, result));
  }

  void _onApproveGuardianRecoveryDeepLink(OnApproveGuardianRecoveryDeepLink event, Emitter<AppState> emit) {
    emit(state.copyWith(showGuardianApproveOrDenyScreen: event.data));
  }

  void _onSigningRequest(OnSigningRequest event, Emitter<AppState> emit) {
    throw UnimplementedError("not implemented");
    // final args = SendConfirmationArguments.from(event.esr);
    // emit(state.copyWith(pageCommand: NavigateToSendConfirmation(args)));
  }
}
