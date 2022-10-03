import 'package:flutter/material.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/utils/ThemeBuildContext.dart';
import 'package:hashed/utils/build_context_extension.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16),
        child: TextButton(
          style: TextButton.styleFrom(
              shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
          onPressed: () {
            if (settingsStorage.inRecoveryMode) {
              NavigationService.of(context)
                  .navigateTo(Routes.recoverAccountDetails, arguments: accountService.currentAccount.address);
            } else {
              NavigationService.of(context).navigateTo(Routes.recoverAccountSearch);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Recover your funds ',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Text(
                'here',
                style: Theme.of(context).textTheme.subtitle2?.copyWith(color: context.colorScheme.secondary),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 120),
              Image.asset("assets/images/login/wallet_logo.png"),
              const SizedBox(height: 120),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.loc.loginFirstTimeHere, style: Theme.of(context).textTheme.subtitle2),
                    const SizedBox(height: 10),
                    FlatButtonLong(
                      onPressed: () => NavigationService.of(context).navigateTo(Routes.signup),
                      title: "Create Account",
                    ),
                    const SizedBox(height: 40),
                    Text("Already have an account?", style: Theme.of(context).textTheme.subtitle2),
                    const SizedBox(height: 10),
                    FlatButtonLong(
                      onPressed: () => NavigationService.of(context).navigateTo(Routes.importKey),
                      title: 'Import Account',
                    )
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
