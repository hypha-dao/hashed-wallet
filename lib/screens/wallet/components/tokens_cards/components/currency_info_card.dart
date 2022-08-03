import 'package:flutter/material.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balance_view_model.dart';
import 'package:seeds/utils/build_context_extension.dart';

class CurrencyInfoCard extends StatelessWidget {
  static const defaultBgImage = 'assets/images/wallet/currency_info_cards/tlos/background.jpg';
  static const seedsEcosysSymbol = 'assets/images/wallet/currency_info_cards/seeds/seeds_check_transp.png';

  final TokenBalanceViewModel tokenBalance;
  final String fiatBalance;
  final double? cardWidth;
  final double? cardHeight;
  final Color? textColor;

  const CurrencyInfoCard(
    this.tokenBalance, {
    super.key,
    this.fiatBalance = "",
    this.cardWidth,
    this.cardHeight,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: tokenBalance.token.backgroundImage, fit: BoxFit.fill),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(tokenBalance.token.name),
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(image: tokenBalance.token.logo, fit: BoxFit.fill),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Text(context.loc.walletCurrencyCardBalance,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(color: textColor)),
                const SizedBox(height: 6),
                Text(tokenBalance.displayQuantity,
                    style: Theme.of(context).textTheme.headline5!.copyWith(color: textColor)),
                const SizedBox(height: 6),
                Text(fiatBalance)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
