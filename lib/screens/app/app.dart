// ignore_for_file: use_decorated_box

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashed/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/components/full_page_loading_indicator.dart';
import 'package:hashed/components/notification_badge.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:hashed/i18n/app/app.i18.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/screens/app/account_under_recovery/account_under_recovery_screen.dart';
import 'package:hashed/screens/app/components/guardian_approve_or_deny_recovery_screen.dart';
import 'package:hashed/screens/app/interactor/viewmodels/app_bloc.dart';
import 'package:hashed/screens/app/interactor/viewmodels/app_page_commands.dart';
import 'package:hashed/screens/app/interactor/viewmodels/app_screen_item.dart';
import 'package:hashed/screens/settings/settings_screen.dart';
import 'package:hashed/screens/transfer/scan/scan_confirmation_screen.dart';
import 'package:hashed/screens/wallet/wallet_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final List<AppScreenItem> _appScreenItems = [
    AppScreenItem(
      title: "Wallet".i18n,
      icon: 'assets/images/navigation_bar/wallet.svg',
      iconSelected: 'assets/images/navigation_bar/wallet_selected.svg',
      screen: const WalletScreen(),
      index: 0,
    ),
    const AppScreenItem(
      title: "Scan",
      icon: 'assets/images/scan.svg',
      iconSelected: 'assets/images/scan.svg',
      screen: ScanConfirmationScreen(),
      // TODO(gguij): remove this to show the scanner
      // screen: SendScannerScreen(),
      index: 1,
    ),
    AppScreenItem(
      title: "Settings".i18n,
      icon: 'assets/images/navigation_bar/carbon_settings_unselected.svg',
      iconSelected: 'assets/images/navigation_bar/carbon_settings_selected.svg',
      screen: const SettingsScreen(),
      index: 2,
    ),
  ];
  final PageController _pageController = PageController();
  late AppBloc _appBloc;

  @override
  void initState() {
    super.initState();
    _appBloc = AppBloc(BlocProvider.of<DeeplinkBloc>(context))..add(const OnAppMounted());
    BlocProvider.of<RatesBloc>(context).add(const OnFetchRates());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        BlocProvider.of<RatesBloc>(context).add(const OnFetchRates());
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _appBloc,
      child: Scaffold(
        body: BlocConsumer<AppBloc, AppState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) async {
            final pageCommand = state.pageCommand;
            _appBloc.add(ClearAppPageCommand());
            if (pageCommand is BottomBarNavigateToIndex) {
              _pageController.jumpToPage(pageCommand.index);
            } else if (pageCommand is ShowErrorMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            } else if (pageCommand is ShowMessage) {
              eventBus.fire(ShowSnackBar(pageCommand.message));
            } else if (pageCommand is NavigateToRoute) {
              await NavigationService.of(context).navigateTo(pageCommand.route);
            } else if (pageCommand is NavigateToRouteWithArguments) {
              if (pageCommand is NavigateToSendConfirmation) {
                await NavigationService.of(context).navigateTo(Routes.verificationUnpoppable).then((_) =>
                    NavigationService.of(context).navigateTo(pageCommand.route, arguments: pageCommand.arguments));
              } else {
                await NavigationService.of(context).navigateTo(pageCommand.route, arguments: pageCommand.arguments);
              }
            }
          },
          builder: (context, state) {
            if (state.pageState == PageState.loading) {
              return const FullPageLoadingIndicator();
            } else {
              if (state.showGuardianRecoveryAlert) {
                return const AccountUnderRecoveryScreen();
              } else if (state.showGuardianApproveOrDenyScreen != null) {
                return GuardianApproveOrDenyScreen(data: state.showGuardianApproveOrDenyScreen!);
              } else {
                return PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _appScreenItems.map((i) => i.screen).toList(),
                );
              }
            }
          },
        ),
        bottomNavigationBar: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          // color: AppColors.white,
                          width: 0.2))),
              child: BottomNavigationBar(
                currentIndex: state.index,
                onTap: (index) => _appBloc.add(BottomBarTapped(index: index)),
                //selectedItemColor: AppColors.white,
                items: [
                  for (var i in _appScreenItems)
                    BottomNavigationBarItem(
                      activeIcon:
                          Padding(padding: const EdgeInsets.only(bottom: 4.0), child: SvgPicture.asset(i.iconSelected)),
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(padding: const EdgeInsets.all(4.0), child: SvgPicture.asset(i.icon)),
                          if (state.hasNotification && i.index == 2)
                            const Positioned(top: -2, right: -16, child: NotificationBadge())
                        ],
                      ),
                      label: state.index == i.index ? i.title : '',
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
