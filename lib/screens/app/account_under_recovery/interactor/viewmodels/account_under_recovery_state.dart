import 'package:equatable/equatable.dart';
import 'package:hashed/datasource/remote/model/active_recovery_model.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';

class AccountUnderRecoveryState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final List<ActiveRecoveryModel>? recoveries;

  const AccountUnderRecoveryState({this.pageState = PageState.initial, this.pageCommand, required this.recoveries});

  factory AccountUnderRecoveryState.initial(List<ActiveRecoveryModel>? recoveries) {
    return AccountUnderRecoveryState(recoveries: recoveries);
  }

  @override
  List<Object?> get props => [pageState];

  AccountUnderRecoveryState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    List<ActiveRecoveryModel>? recoveries,
  }) {
    return AccountUnderRecoveryState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      recoveries: recoveries ?? this.recoveries,
    );
  }
}
