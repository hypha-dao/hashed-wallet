import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/dots_indicator.dart';
import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/components/currency_info_card.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_bloc.dart';
import 'package:seeds/screens/wallet/components/wallet_buttons.dart';
import 'package:seeds/screens/wallet/interactor/viewmodels/wallet_bloc.dart';

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
                      Expanded(child: WalletButtons(onPressed: () {}, title: 'Send')),
                      const SizedBox(width: 16),
                      Expanded(
                        child: WalletButtons(
                          title: 'Start Service',
                          onPressed: () async {
                            // testing substrate service - leave this for now
                            print("startService..");

                            await polkadotRepository.startService();
                            print("start service finished...");
                          },
                          buttonType: ButtonsType.receiveButton,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: WalletButtons(
                          title: 'Create acct',
                          onPressed: () {
                            print("Create account");
                            polkadotRepository.createKey();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: WalletButtons(
                          title: 'Stop Service',
                          onPressed: () async {
                            // testing substrate service - leave this for now
                            print("disable web view");

                            print("Stop service.");

                            await polkadotRepository.stopService();

                            print("isRunning ${polkadotRepository.isRunning}");
                          },
                          buttonType: ButtonsType.receiveButton,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: WalletButtons(
                          title: 'Test Import',
                          onPressed: () {
                            print("test import");
                            polkadotRepository.testImport();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: WalletButtons(
                          title: 'Test 3',
                          onPressed: () async {
                            // testing substrate service - leave this for now
                            print("test 3");

                            // this is one of our demo accounts with a balance on polkadot
                            final addr = "5GwwAKFomhgd4AHXZLUBVK3B792DvgQUnoHTtQNkwmt5h17k";

                            final res = await polkadotRepository.getBalance(addr);

                            print("get balance result: $res");
//                             flutter: getBalance res: {nonce: 2, consumers: 0, providers: 1, sufficients: 0, data: {free: 1499366495076723, reserved: 33333333000, miscFrozen: 0, feeFrozen: 0}}
// flutter: get balance result: {nonce: 2, consumers: 0, providers: 1, sufficients: 0, data: {free: 1499366495076723, reserved: 33333333000, miscFrozen: 0, feeFrozen: 0}}
                          },
                          buttonType: ButtonsType.receiveButton,
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
