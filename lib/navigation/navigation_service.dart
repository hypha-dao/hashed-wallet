import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/authentication/import_key/import_key_screen.dart';
import 'package:seeds/screens/authentication/import_key/import_words_screen.dart';
import 'package:seeds/screens/authentication/login_screen.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/recover_account_found_screen.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/recover_account_search_screen.dart';
import 'package:seeds/screens/authentication/sign_up/signup_screen.dart';
import 'package:seeds/screens/authentication/splash_screen.dart';
import 'package:seeds/screens/authentication/verification/verification_screen.dart';
import 'package:seeds/screens/profile_screens/edit_name/edit_name_screen.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/guardians_screen.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians/invite_guardian_screen.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians_sent/invite_guardians_sent_screen.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/select_guardians_screen.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/recovery_phrase_screen.dart';
import 'package:seeds/screens/profile_screens/set_currency/set_currency_screen.dart';
import 'package:seeds/screens/profile_screens/settings/settings_screen.dart';
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/receive_detail_qr_code.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/receive_seeds_screen.dart';
import 'package:seeds/screens/transfer/receive/receive_selection/receive_screen.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/send_confirmation_screen.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/transaction_actions_screen.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/send_enter_data_screen.dart';
import 'package:seeds/screens/transfer/send/send_scanner/send_scanner_screen.dart';
import 'package:seeds/screens/transfer/send/send_search_user/send_search_user_screen.dart';

/// Add only current routes in the app and that are used by [NavigationService]
class Routes {
  static const splash = 'splash';
  static const app = 'app';
  static const login = 'login';
  static const importKey = 'importKey';
  static const importWords = 'importWords';
  static const verification = 'verification';
  static const verificationUnpoppable = 'verificationUnpoppable';
  static const signup = 'signup';
  static const recoverAccountSearch = 'recoverAccountSearch';
  static const recoveryPhrase = 'recoveryPhrase';
  static const recoverAccountFound = 'recoverAccountFound';
  static const transfer = 'transfer';
  static const sendEnterData = 'sendEnterData';
  static const delegate = 'delegate';
  static const delegateAUser = 'delegateAUser';
  static const createInvite = 'createInvite';
  static const flag = 'flag';
  static const flagUser = 'flagUser';
  static const vote = 'vote';
  static const proposalDetails = 'proposalDetails';
  static const plantSeeds = 'plantSeeds';
  static const vouch = 'vouch';
  static const vouchForAMember = 'vouchForAMember';
  static const unPlantSeeds = 'unPlantSeeds';
  static const sendConfirmation = 'sendConfirmation';
  static const transactionActions = 'transactionActions';
  static const scanQRCode = 'scanQRCode';
  static const swapSeeds = 'swapSeeds';
  static const receiveScreen = 'receiveScreen'; // TODO(gguij002): Route not yet implemented
  static const receiveEnterData = 'receiveEnterData';
  static const receiveQR = 'receiveQR';
  static const selectGuardians = 'selectGuardians';
  static const inviteGuardians = 'inviteGuardians';
  static const inviteGuardiansSent = 'inviteGuardiansSent';
  static const guardianTabs = 'guardianTabs';
  static const manageInvites = 'manageInvites';
  static const support = 'support';
  static const security = 'security';
  static const editName = 'editName';
  static const setCurrency = 'setCurrency';
}

class NavigationService {
  final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
  final _appRoutes = {
    Routes.splash: (_) => const SplashScreen(),
    Routes.login: (_) => const LoginScreen(),
    Routes.importKey: (_) => const ImportKeyScreen(),
    Routes.importWords: (_) => const ImportWordsScreen(),
    Routes.verification: (_) => const VerificationScreen(),
    Routes.verificationUnpoppable: (_) => const VerificationScreen.unpoppable(),
    Routes.recoverAccountSearch: (_) => const RecoverAccountSearchScreen(),
    Routes.recoverAccountFound: (_) => const RecoverAccountFoundScreen(),
    Routes.signup: (_) => const SignupScreen(),
    Routes.app: (_) => const App(),
    Routes.transfer: (_) => const SendSearchUserScreen(),
    Routes.sendEnterData: (_) => const SendEnterDataScreen(),
    Routes.sendConfirmation: (args) => const SendConfirmationScreen(),
    Routes.transactionActions: (_) => const TransactionActionsScreen(),
    Routes.scanQRCode: (_) => const SendScannerScreen(),
    Routes.receiveScreen: (_) => const ReceiveScreen(), // <- This route is not used
    Routes.receiveEnterData: (_) => const ReceiveEnterDataScreen(),
    Routes.receiveQR: (args) => ReceiveDetailQrCodeScreen(args),
    Routes.selectGuardians: (_) => const SelectGuardiansScreen(),
    Routes.inviteGuardians: (args) => const InviteGuardians(),
    Routes.inviteGuardiansSent: (_) => const InviteGuardiansSentScreen(),
    Routes.guardianTabs: (_) => const GuardiansScreen(),
    Routes.security: (_) => const SettingsScreen(),
    Routes.editName: (_) => const EditNameScreen(),
    Routes.setCurrency: (_) => const SetCurrencyScreen(),
    Routes.recoveryPhrase: (_) => const RecoveryPhraseScreen(),
  };

  // iOS: full screen routes pop up from the bottom and disappear vertically too
  // On iOS that's a standard full screen dialog
  // Has no effect on Android.
  final _fullScreenRoutes = {
    Routes.verificationUnpoppable,
  };

  static NavigationService of(BuildContext context) => RepositoryProvider.of<NavigationService>(context);

  Future<dynamic> navigateTo(String routeName, [Object? arguments, bool replace = false]) async {
    if (_appRoutes[routeName] != null) {
      if (replace) {
        return appNavigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
      } else {
        return appNavigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
      }
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
