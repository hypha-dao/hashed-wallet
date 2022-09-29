import 'package:flutter_test/flutter_test.dart';
import 'package:hashed/screens/authentication/recover/recover_account_found/interactor/viewmodels/current_remaining_time.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/interactor/usecase/remaining_time_state_mapper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void expectTime(CurrentRemainingTime time, {int days = 0, int hours = 0, int minutes = 0, int seconds = 0}) {
    expect(time.days, days);
    expect(time.hours, hours);
    expect(time.min, minutes);
    expect(time.sec, seconds);
  }

  test('test time remaining', () async {
    final mapper = RemainingTimeStateMapper();

    var t = mapper.getRemainingTime(10);
    expectTime(t, seconds: 10);

    t = mapper.getRemainingTime(60);
    expectTime(t, minutes: 1);

    t = mapper.getRemainingTime(61);
    expectTime(t, minutes: 1, seconds: 1);

    final secondsPerMinute = 60;
    final secondsPerHour = secondsPerMinute * 60;
    final secondsPerDay = secondsPerHour * 24;

    final remaining = 3 * secondsPerDay + 23 * secondsPerHour + 59 * secondsPerMinute + 59;
    t = mapper.getRemainingTime(remaining);

    expectTime(t, days: 3, hours: 23, minutes: 59, seconds: 59);

    t = mapper.getRemainingTime(0);
    expectTime(t);

    t = mapper.getRemainingTime(-1);
    expectTime(t);
    
  });
}
