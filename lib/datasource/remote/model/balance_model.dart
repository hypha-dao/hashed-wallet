import 'package:hashed/datasource/remote/model/token_model.dart';

/// The available balance of seeds
class BalanceModel {
  final double quantity;
  final bool hasBalance;

  const BalanceModel(this.quantity, {this.hasBalance = true});

  factory BalanceModel.fromJson(List<dynamic> json) {
    if (json.isEmpty || json[0].isEmpty) {
      return const BalanceModel(0, hasBalance: false);
    } else {
      final amount = double.parse((json[0] as String).split(' ').first);
      return BalanceModel(amount);
    }
  }
}

class TokenBalanceModel {
  final BalanceModel balance;
  final TokenModel token;

  double get quantity => balance.quantity;
  String get asAssetString => token.getAssetString(balance.quantity);

  TokenBalanceModel(this.balance, this.token);
}
