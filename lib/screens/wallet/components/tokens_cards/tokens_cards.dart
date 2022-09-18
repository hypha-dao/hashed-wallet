import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/components/dots_indicator.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/domain-shared/shared_use_cases/cerate_firebase_dynamic_link_use_case.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/wallet/components/tokens_cards/components/currency_info_card.dart';
import 'package:hashed/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_bloc.dart';
import 'package:hashed/screens/wallet/components/wallet_buttons.dart';
import 'package:hashed/screens/wallet/interactor/viewmodels/wallet_bloc.dart';

class TokenCards extends StatefulWidget {
  const TokenCards({super.key});

  @override
  _TokenCardsState createState() => _TokenCardsState();
}

class _TokenCardsState extends State<TokenCards> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => TokenBalancesBloc()..add(const OnLoadTokenBalances()),
      child: BlocListener<WalletBloc, WalletState>(
        listenWhen: (_, current) => current.pageState == PageState.loading,
        listener: (context, _) {
          BlocProvider.of<TokenBalancesBloc>(context).add(const OnLoadTokenBalances());
        },
        child: BlocBuilder<TokenBalancesBloc, TokenBalancesState>(
          builder: (context, state) {
            return Column(
              children: [
                SingleChildScrollView(
                  child: CarouselSlider(
                    items: [
                      for (var tokenBalanceViewModel in state.availableTokens)
                        Container(
                          margin: EdgeInsets.only(
                              left: tokenBalanceViewModel.token == state.availableTokens.first.token ? 0 : 10.0,
                              right: tokenBalanceViewModel.token == state.availableTokens.last.token ? 0 : 10.0),
                          child: CurrencyInfoCard(
                            tokenBalanceViewModel,
                            fiatBalance:
                                tokenBalanceViewModel.fiatValueString(BlocProvider.of<RatesBloc>(context).state),
                          ),
                        ),
                    ],
                    options: CarouselOptions(
                      height: 220,
                      viewportFraction: 0.89,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, _) {
                        BlocProvider.of<TokenBalancesBloc>(context).add(OnSelectedTokenChanged(index));
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DotsIndicator(dotsCount: state.availableTokens.length, position: state.selectedIndex.toDouble()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: WalletButtons(
                          onPressed: () => NavigationService.of(context).navigateTo(Routes.transfer),
                          title: 'Send',
                        ),
                      ),
                      const SizedBox(width: 16),
                      // ignore: prefer_const_constructors
                      Expanded(
                        // ignore: prefer_const_constructors
                        child: WalletButtons(
                          title: 'Receive',
                          onPressed: () async {
                            final link = await CreateFirebaseDynamicLinkUseCase().createDynamicLink(
                                GuardianRecoveryRequestData(lostAccount: "0x0111", rescuer: "0x0222"));

                            print("firebase deep link: ${link.asValue?.value}");
                            // polkadotRepository.recoveryRepository
                            //     .getActiveRecoveries(accountService.currentAccount.address);
                          },
                          buttonType: ButtonsType.receiveButton,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
