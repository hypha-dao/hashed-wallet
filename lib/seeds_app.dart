import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hashed/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:hashed/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:hashed/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:hashed/blocs/root/root_bloc.dart';
import 'package:hashed/components/snack.dart';
import 'package:hashed/design/app_theme.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:i18n_extension/i18n_widget.dart';

class HashedApp extends StatelessWidget {
  const HashedApp({super.key});

  @override
  Widget build(BuildContext context) {
    final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    return RepositoryProvider(
      create: (_) => NavigationService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RootBloc>(create: (_) => RootBloc()),
          BlocProvider<AuthenticationBloc>(create: (_) => AuthenticationBloc()..add(const InitAuthStatus())),
          BlocProvider<RatesBloc>(create: (_) => RatesBloc()),
          BlocProvider<DeeplinkBloc>(create: (_) => DeeplinkBloc()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<RootBloc, RootState>(
              listenWhen: (_, current) => current.busEvent != null,
              listener: (context, state) {
                final BusEvent busEvent = state.busEvent!;
                BlocProvider.of<RootBloc>(context).add(const ClearRootBusEvent());
                if (busEvent is ShowSnackBar) {
                  final ShowSnackBar event = busEvent;
                  Snack(event.message, rootScaffoldMessengerKey.currentState!).show();
                }
              },
            ),
          ],
          child: Builder(
            builder: (context) {
              final navigator = NavigationService.of(context);
              return GestureDetector(
                onTap: () => BlocProvider.of<AuthenticationBloc>(context).add(const InitAuthTimer()),
                onPanDown: (_) => BlocProvider.of<AuthenticationBloc>(context).add(const InitAuthTimer()),
                onPanUpdate: (_) => BlocProvider.of<AuthenticationBloc>(context).add(const InitAuthTimer()),
                child: MaterialApp(
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  theme: SeedsAppTheme.darkTheme,
                  scaffoldMessengerKey: rootScaffoldMessengerKey,
                  navigatorKey: navigator.appNavigatorKey,
                  onGenerateRoute: navigator.onGenerateRoute,
                  builder: (_, child) {
                    return I18n(
                      child: BlocListener<AuthenticationBloc, AuthenticationState>(
                        listenWhen: (previous, current) => previous.authStatus != current.authStatus,
                        listener: (_, state) {
                          switch (state.authStatus) {
                            case AuthStatus.emptyAccount:
                              navigator.pushAndRemoveAll(Routes.login);
                              break;
                            case AuthStatus.inviteLink:
                              navigator.pushAndRemoveAll(Routes.signup);
                              break;
                            case AuthStatus.recoveryMode:
                              navigator.pushAndRemoveAll(Routes.login);
                              break;
                            case AuthStatus.emptyPasscode:
                            case AuthStatus.locked:
                              if (navigator.currentRouteName() == null ||
                                  navigator.currentRouteName() == Routes.importKey) {
                                navigator.pushAndRemoveAll(Routes.app);
                              }
                              navigator.navigateTo(Routes.verificationUnpoppable);
                              break;
                            case AuthStatus.unlocked:
                              navigator.pushApp();
                              break;
                            default:
                              navigator.pushAndRemoveAll(Routes.splash);
                              break;
                          }
                        },
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
