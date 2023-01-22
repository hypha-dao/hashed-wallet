part of 'send_confirmation_bloc.dart';

class SendTransaction {
  final Account from;
  final Account to;
  final TokenDataModel quantity;

  Map<String, dynamic> get data => {
        "to": to,
        "amount": quantity,
      };

  SendTransaction(this.from, this.to, this.quantity);
}

class SendConfirmationState extends Equatable {
  final PageState pageState;
  final TransactionPageCommand? pageCommand;
  final String? errorMessage;
  final SendTransaction transaction;
  final String? callback;
  final TransactionResult transactionResult;
  final InvalidTransaction invalidTransaction;

  bool get isTransfer => true;

  const SendConfirmationState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.transaction,
    this.callback,
    required this.transactionResult,
    required this.invalidTransaction,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        transaction,
        transactionResult,
        invalidTransaction,
      ];

  SendConfirmationState copyWith({
    PageState? pageState,
    TransactionPageCommand? pageCommand,
    String? errorMessage,
    SendTransaction? transaction,
    String? callback,
    TransactionResult? transactionResult,
    InvalidTransaction? invalidTransaction,
  }) {
    return SendConfirmationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      transaction: transaction ?? this.transaction,
      callback: callback ?? this.callback,
      transactionResult: transactionResult ?? this.transactionResult,
      invalidTransaction: invalidTransaction ?? this.invalidTransaction,
    );
  }

  factory SendConfirmationState.initial(SendConfirmationArguments arguments) {
    return SendConfirmationState(
      pageState: PageState.initial,
      transaction: arguments.transaction,
      transactionResult: const TransactionResult(),
      invalidTransaction: InvalidTransaction.none,
      callback: arguments.callback,
    );
  }
}

enum InvalidTransaction { none, insufficientBalance, alreadyInvited }
