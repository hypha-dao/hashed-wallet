import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/authentication/recover/recover_account_found/interactor/viewmodels/current_remaining_time.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/interactor/viewmodels/recover_account_timer_bloc.dart';

///Seconds in a day
const int _daySecond = 60 * 60 * 24;

///Seconds in an hour
const int _hourSecond = 60 * 60;

///Seconds in a minute
const int _minuteSecond = 60;

class RemainingTimeStateMapper {
  RecoverAccountTimerState mapResultToState(RecoverAccountTimerState currentState) {
    final remaining = getRemainingTime(currentState.timeRemaining);
    return currentState.copyWith(
      pageState: PageState.success,
      currentRemainingTime: remaining,
    );
  }

  CurrentRemainingTime getRemainingTime(int remainingSeconds) {
    int days = 0;
    int hours = 0;
    int min = 0;
    int seconds = remainingSeconds;

    if (seconds <= 0) {
      return CurrentRemainingTime.zero();
    }

    ///Calculate the number of days remaining.
    if (seconds >= _daySecond) {
      days = seconds ~/ _daySecond;
      seconds %= _daySecond;
    }

    ///Calculate remaining hours.
    if (seconds >= _hourSecond) {
      hours = seconds ~/ _hourSecond;
      seconds %= _hourSecond;
    } else if (days != 0) {
      hours = 0;
    }

    ///Calculate remaining minutes.
    if (seconds >= _minuteSecond) {
      min = seconds ~/ _minuteSecond;
      seconds %= _minuteSecond;
    } else if (hours != 0) {
      min = 0;
    }

    return CurrentRemainingTime(
      days: days,
      hours: hours,
      min: min,
      sec: seconds,
    );
  }
}
