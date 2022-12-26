import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/components/dots_indicator.dart';
import 'package:hashed/datasource/remote/polkadot_api/chains_repository.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/page_state.dart';
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
                          onPressed: () async {
                            await NavigationService.of(context).navigateTo(Routes.transfer);
                          },
                          title: 'Send',
                        ),
                      ),
                      const SizedBox(width: 16),
                      // ignore: prefer_const_constructors
                      Expanded(
                        // ignore: prefer_const_constructors
                        child: WalletButtons(
                          title: 'Receive ${polkadotRepository.state.isConnected ? " C" : " d"}',
                          onPressed: () async {
                            final val = await polkadotRepository.getChainProperties();
                            // if (polkadotRepository.state.isConnected) {
                            //   print("stop service...");
                            //   await polkadotRepository.stopService();
                            //   print("stop service done.");
                            // } else {
                            //   print("stop service...");
                            //   await polkadotRepository.stopService();

                            //   final currentNetwork = await chainsRepository.currentNetwork();
                            //   print("start service...${currentNetwork.name} ${currentNetwork.endpoints}");
                            //   await polkadotRepository.initService(currentNetwork, force: true);
                            //   print("init done.");
                            //   await polkadotRepository.startService();
                            //   print("start service done");
                            // }

                            // final address = "5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym";
                            // final valid = await polkadotRepository.validateAddress(address);
                            // print("is valud: $valid");

                            // final address = "5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym";

                            // final address = "5DDEc9t4iZYb4aQ7Gqzxvda6MkRQDQM3WDPJeK1bb5h8LFVb";
                            // final res = await polkadotRepository.recoveryRepository.getProxies(address);

                            // final recovery = res.asValue!.value;
                            // // ignore: unnecessary_brace_in_string_interps
                            // print("recovery: ${recovery} ");

                            /// get last block
                            // final res = await polkadotRepository.getLastBlockNumber();
                            // print("last block: ${res.asValue!.value}");

                            // get recovery
                            // final lostAccount = "5HGZfBpqUUqGY7uRCYA6aRwnRHJVhrikn8to31GcfNcifkym";
                            // final rescuer = "5G6XUFXZsdUYdB84eEjvPP33tFF1DjbSg7MPsNAx3mVDnxaW";
                            // final res = await polkadotRepository.recoveryRepository
                            //     .getActiveRecoveriesForLostaccount(rescuer, lostAccount);

                            // final recovery = res.asValue!.value;
                            // print("recovery: ${recovery!.toJson()} ");

                            // print("firebase deep link: ${link.asValue?.value}");

                            // create link
                            // final link = await CreateFirebaseDynamicLinkUseCase().createDynamicLink(
                            //     GuardianRecoveryRequestData(lostAccount: "0x0111", rescuer: "0x0222"));

                            // print("firebase deep link: ${link.asValue?.value}");

                            // get active recoveries
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
