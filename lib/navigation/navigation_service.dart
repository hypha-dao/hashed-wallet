import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/screens/app/account_under_recovery/account_under_recovery_screen.dart';
import 'package:hashed/screens/app/app.dart';
import 'package:hashed/screens/authentication/create_nickname/create_nickname_screen.dart';
import 'package:hashed/screens/authentication/import_key/import_key_screen.dart';
import 'package:hashed/screens/authentication/login_screen.dart';
import 'package:hashed/screens/authentication/recover/recover_account_details/recover_account_details_page.dart';
import 'package:hashed/screens/authentication/recover/recover_account_overview/recover_account_overview_page.dart';
import 'package:hashed/screens/authentication/recover/recover_account_search/recover_account_screen.dart';
import 'package:hashed/screens/authentication/recover/recover_account_success/recover_account_success_page.dart';
import 'package:hashed/screens/authentication/recover/recover_account_timer/recover_account_timer_page.dart';
import 'package:hashed/screens/authentication/sign_up/signup_screen.dart';
import 'package:hashed/screens/authentication/splash_screen.dart';
import 'package:hashed/screens/authentication/verification/verification_screen.dart';
import 'package:hashed/screens/profile_screens/edit_name/edit_name_screen.dart';
import 'package:hashed/screens/profile_screens/export_private_key/export_private_key_screen.dart';
import 'package:hashed/screens/profile_screens/guardians/guardians_tabs/guardians_screen.dart';
import 'package:hashed/screens/profile_screens/guardians/select_guardian/select_guardians_screen_v3.dart';
import 'package:hashed/screens/profile_screens/recovery_phrase/recovery_phrase_screen.dart';
import 'package:hashed/screens/profile_screens/set_currency/set_currency_screen.dart';
import 'package:hashed/screens/profile_screens/switch_network/switch_network_screen.dart';
import 'package:hashed/screens/settings/settings_screen.dart';
import 'package:hashed/screens/transfer/receive/receive_detail_qr_code/receive_detail_qr_code.dart';
import 'package:hashed/screens/transfer/receive/receive_enter_data/receive_seeds_screen.dart';
import 'package:hashed/screens/transfer/scan/scan_confirmation_screen.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/transaction_actions_screen.dart';
import 'package:hashed/screens/transfer/send/send_enter_data/send_enter_data_screen.dart';
import 'package:hashed/screens/transfer/send/send_search_user/send_search_user_screen.dart';

/// Add only current routes in the app and that are used by [NavigationService]
class Routes {
  static const splash = 'splash';
  static const app = 'app';
  static const login = 'login';
  static const importKey = 'importKey';
  static const createNickname = 'createNickname';
  static const verification = 'verification';
  static const verificationUnpoppable = 'verificationUnpoppable';
  static const signup = 'signup';
  static const recoverAccountSearch = 'recoverAccountSearch';
  static const recoveryPhrase = 'recoveryPhrase';
  static const recoverAccountOverview = 'recoverAccountOverview';
  static const recoverAccountDetails = 'recoverAccountDetails';
  static const recoverAccountSuccess = 'recoverAccountSuccess';
  static const recoverAccountTimer = 'recoverAccountTimer';
  static const transfer = 'transfer';
  static const sendEnterData = 'sendEnterData';

  static const createInvite = 'createInvite';

  static const scanConfirmation = 'scanConfirmation';
  static const transactionActions = 'transactionActions';

  static const receiveScreen = 'receiveScreen';
  static const receiveEnterData = 'receiveEnterData';

  static const receiveQR = 'receiveQR';
  static const profile = 'profile';
  static const selectGuardians = 'selectGuardians';
  static const guardianTabs = 'guardianTabs';

  static const support = 'support';
  static const security = 'security';
  static const editName = 'editName';
  static const exportPrivateKey = ' exportPrivateKey';
  static const switchNetwork = ' switchNetwork';
  static const setCurrency = 'setCurrency';
  static const citizenship = 'citizenship';

  static const accountUnderRecoveryScreen = "accountUnderRecoveryScreen";
}

class NavigationService {
  final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
  final _appRoutes = {
    Routes.splash: (_) => const SplashScreen(),
    Routes.login: (_) => const LoginScreen(),
    Routes.importKey: (_) => ImportKeyScreen(),
    Routes.createNickname: (_) => const CreateNicknameScreen(),
    Routes.verification: (_) => const VerificationScreen(),
    Routes.verificationUnpoppable: (_) => const VerificationScreen.unpoppable(),
    Routes.recoverAccountSearch: (_) => const RecoverAccountScreen(),
    Routes.recoverAccountOverview: (_) => const RecoverAccountOverviewPage(),
    Routes.recoverAccountDetails: (_) => const RecoverAccountDetailsPage(),
    Routes.recoverAccountSuccess: (_) => const RecoverAccountSuccessPage(),
    Routes.recoverAccountTimer: (_) => const RecoverAccountTimerPage(),
    Routes.signup: (_) => const SignupScreen(),
    Routes.app: (_) => const App(),
    Routes.transfer: (_) => const SendSearchUserScreen(),
    Routes.sendEnterData: (_) => const SendEnterDataScreen(),
    Routes.scanConfirmation: (args) => ScanConfirmationScreen(args),
    Routes.transactionActions: (_) => const TransactionActionsScreen(),
    Routes.receiveQR: (args) => ReceiveDetailQrCodeScreen(args),
    Routes.selectGuardians: (_) => const SelectGuardiansScreenV3(),
    Routes.guardianTabs: (_) => const GuardiansScreen(),
    Routes.security: (_) => const SettingsScreen(),
    Routes.editName: (_) => const EditNameScreen(),
    Routes.exportPrivateKey: (_) => const ExportPrivateKeyScreen(),
    Routes.switchNetwork: (_) => const SwitchNetworkScreen(),
    Routes.setCurrency: (_) => const SetCurrencyScreen(),
    Routes.citizenship: (_) => const SettingsScreen(),
    Routes.recoveryPhrase: (_) => const RecoveryPhraseScreen(),
    Routes.accountUnderRecoveryScreen: (_) => const AccountUnderRecoveryScreen(),
    Routes.receiveEnterData: (_) => const ReceiveEnterDataScreen(),
  };

  // iOS: full screen routes pop up from the bottom and disappear vertically too
  // On iOS that's a standard full screen dialog
  // Has no effect on Android.
  final _fullScreenRoutes = {
    Routes.verificationUnpoppable,
    Routes.accountUnderRecoveryScreen,
  };

  // iOS transition: Pages that slides in from the right and exits in reverse.
  final _cupertinoRoutes = {
    Routes.citizenship,
  };

  static NavigationService of(BuildContext context) => RepositoryProvider.of<NavigationService>(context);

  // TODO(n13): refactor this to named arguments for arguments, replace; too much Voodoo here
  Future<dynamic> navigateTo(String routeName, {Object? arguments, bool replace = false}) async {
    if (_appRoutes[routeName] != null) {
      if (replace) {
        return appNavigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
      } else {
        return appNavigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
      }
    }
  }

  // Go home and reset all screens - after scan.
  Future<dynamic> goToHomeScreen() async {
    await navigateTo(Routes.app, replace: true);
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (_appRoutes[settings.name!] != null) {
      if (_cupertinoRoutes.contains(settings.name)) {
        // Pages that slides in from the right and exits in reverse
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => _appRoutes[settings.name]!(settings.arguments),
          fullscreenDialog: _fullScreenRoutes.contains(settings.name),
        );
      } else {
        // Pages slides the route upwards and fades it in, and exits in reverse
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => _appRoutes[settings.name]!(settings.arguments),
          fullscreenDialog: _fullScreenRoutes.contains(settings.name),
        );
      }
    } else {
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }

  Future<dynamic> pushAndRemoveAll(String routeName, [Object? arguments]) async {
    return appNavigatorKey.currentState?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  /// Push LW App.
  ///
  /// If there is a route in stack and is verification, pop any other on top.
  Future<dynamic> pushApp() async {
    if (currentRouteName() != null && currentRouteName() == Routes.verificationUnpoppable) {
      return appNavigatorKey.currentState?.popUntil((route) => route.settings.name != Routes.verificationUnpoppable);
    }
    return pushAndRemoveAll(Routes.app);
  }

  String? currentRouteName() {
    String? currentPath;
    appNavigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    return currentPath;
  }

  Future<dynamic> pushAndRemoveUntil({required String route, required String from, Object? arguments}) async {
    return appNavigatorKey.currentState?.pushNamedAndRemoveUntil(route, ModalRoute.withName(from));
  }
}
