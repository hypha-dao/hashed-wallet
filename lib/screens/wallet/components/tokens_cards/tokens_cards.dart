import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/components/dots_indicator.dart';
import 'package:hashed/components/flat_button_long_outlined.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/wallet/components/tokens_cards/components/currency_info_card.dart';
import 'package:hashed/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_bloc.dart';
import 'package:hashed/screens/wallet/components/wallet_buttons.dart';
import 'package:hashed/screens/wallet/interactor/viewmodels/wallet_bloc.dart';
import 'package:share_plus/share_plus.dart';

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
                            print("Transfer...");
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
                            print("receive");
                            _showActionSheet(context);
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

  void _shareAccountAddress() {
    Share.share(accountService.currentAccount.address);
  }

  /// Might use Android bottom sheet if cupertino looks bad on Android..
  // ignore: unused_element
  void _showActionSheetAndroid(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;
    final itemStyle = Theme.of(context).textTheme.labelLarge;
    // ignore: unawaited_futures
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Receive',
                    style: textStyle,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    child: Text("Share Address", style: itemStyle),
                    onTap: () {
                      Navigator.pop(context);
                      _shareAccountAddress();
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    child: const Text("QR Code"),
                    onTap: () => NavigationService.of(context).navigateTo(Routes.receiveEnterData),
                  ),
                  const SizedBox(height: 16),
                  FlatButtonLongOutlined(
                    title: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Receive'),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        // message: const Text('Message'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _shareAccountAddress();
            },
            child: Text(
              'Share Address',
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              NavigationService.of(context).navigateTo(Routes.receiveEnterData);
            },
            child: Text(
              'QR Code',
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
        ],
      ),
    );
  }
}
