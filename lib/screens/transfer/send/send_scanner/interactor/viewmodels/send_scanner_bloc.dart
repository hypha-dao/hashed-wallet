import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/screens/transfer/send/send_scanner/interactor/usecases/scanner_use_case.dart';

part 'send_scanner_event.dart';
part 'send_scanner_state.dart';

class SendScannerBloc extends Bloc<SendScannerEvent, SendScannerState> {
  SendScannerBloc() : super(SendScannerState.initial()) {
    on<InitializeScanner>(_init);
    on<ExecuteScanResult>(_executeScanResult);
    on<ClearSendScannerPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _executeScanResult(ExecuteScanResult event, Emitter<SendScannerState> emit) async {
    // If we are loading, dont handle any upcoming commands
    if (state.pageState != PageState.loading) {
      emit(state.copyWith(pageState: PageState.loading));
      final result = await ProcessScanResultUseCase().run(event.scanResult);
      if (result is ErrorResult) {
        emit(state.copyWith(pageState: PageState.failure, errorMessage: result.error.toString()));
      } else {
        final scanQrCodeResultData = result.asValue!.value;
        emit(state.copyWith(pageCommand: NavigateToScanConfirmation(scanQrCodeResultData)));
      }
    }
  }

  Future<void> _init(InitializeScanner event, Emitter<SendScannerState> emit) async {
    emit(SendScannerState.initial());
  }
}
