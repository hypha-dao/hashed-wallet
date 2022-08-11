import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/datasource/remote/firebase/firebase_push_notification_service.dart';
import 'package:hashed/datasource/remote/model/firebase_models/push_notification_data.dart';
import 'package:hashed/screens/transfer/receive/receive_detail_qr_code/components/receive_paid_success_dialog.dart';
import 'package:hashed/screens/transfer/receive/receive_detail_qr_code/interactor/viewmodels/receive_details.dart';

part 'receive_details_event.dart';
part 'receive_details_state.dart';

class ReceiveDetailsBloc extends Bloc<ReceiveDetailsEvent, ReceiveDetailsState> {
  late final StreamSubscription<PushNotificationData> _pushNotificationtListener;
  late final StreamSubscription<int> _pollListener;
  // [POLKA] clean this up
  // ignore: unused_field
  final RatesState _rateState;

  ReceiveDetailsBloc(ReceiveDetails details, this._rateState) : super(ReceiveDetailsState.initial(details)) {
    _pushNotificationtListener = PushNotificationService().notificationStream.listen((data) {
      if (data.notificationType != null && data.notificationType == NotificationTypes.paymentReceived) {
        add(const OnPaymentReceived());
      }
    });
    _pollListener =
        Stream.periodic(const Duration(seconds: 5), (x) => x).listen((_) => add(const OnPollCheckPayment()));
    on<OnPaymentReceived>(_checkPayment);
    on<OnPollCheckPayment>(_checkPayment);
    on<OnCheckPaymentButtonPressed>(_checkPayment);
  }

  @override
  Future<void> close() async {
    await _pushNotificationtListener.cancel();
    await _pollListener.cancel();
    return super.close();
  }

  Future<void> _checkPayment(ReceiveDetailsEvent event, Emitter<ReceiveDetailsState> emit) async {
    throw UnimplementedError();
  }
}
