part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class OnAppMounted extends AppEvent {
  const OnAppMounted();

  @override
  String toString() => 'OnAppMounted';
}

class ShouldShowNotificationBadge extends AppEvent {
  final bool value;

  const ShouldShowNotificationBadge({required this.value});

  @override
  String toString() => 'ShouldShowNotificationBadge { value: $value }';
}

class BottomBarTapped extends AppEvent {
  final int index;

  const BottomBarTapped({required this.index});

  @override
  String toString() => 'BottomBarTapped { index: $index }';
}

class OnApproveGuardianRecoveryTapped extends AppEvent {
  final GuardianRecoveryRequestData data;

  const OnApproveGuardianRecoveryTapped(this.data);

  @override
  String toString() => 'OnApproveGuardianRecoveryTapped';
}

class OnDismissGuardianRecoveryTapped extends AppEvent {
  @override
  String toString() => 'OnDismissGuardianRecoveryTapped';
}

class ClearAppPageCommand extends AppEvent {
  @override
  String toString() => 'ClearAppPageCommand';
}

class OnApproveGuardianRecoveryDeepLink extends AppEvent {
  final GuardianRecoveryRequestData data;

  const OnApproveGuardianRecoveryDeepLink(this.data);

  @override
  String toString() => 'OnApproveGuardianRecoveryDeepLink';
}

class OnSigningRequest extends AppEvent {
  final ScanQrCodeResultData esr;

  const OnSigningRequest(this.esr);

  @override
  String toString() => 'OnSigningRequest';
}
