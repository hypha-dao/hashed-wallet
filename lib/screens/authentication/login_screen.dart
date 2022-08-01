import 'package:flutter/material.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/datasource/local/account_service.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/utils/build_context_extension.dart';

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
                  .navigateTo(Routes.recoverAccountFound, accountService.currentAccount.address);
            } else {
              NavigationService.of(context).navigateTo(Routes.recoverAccountSearch);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Recover your funds ', style: Theme.of(context).textTheme.subtitle2),
              const Text('here'),
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
                      onPressed: () async {
                        // NavigationService.of(context).navigateTo(Routes.importKey);
                        // testing substrate service - leave this for now
                        print("test public for priv");

                        // pub for priv test
                        // known mnemonic, well, now it is - don't use it for funds
                        const mnemonic1 = 'sample split bamboo west visual approve brain fox arch impact relief smile';
                        // mnemonic1 as sr25519 ==> 5FLiLdaQQiW7qm7tdZjdonfSV8HAcjLxFVcqv9WDbceTmBXA
                        final publicKey = await polkadotRepository.publicKeyForPrivateKey(mnemonic1);
                        print("res $publicKey");

                        await accountService.createAccount(name: "Test 1", privateKey: mnemonic1);

                        final priv = await polkadotRepository.privateKeyForPublicKey(publicKey!);
                        print("priv $priv"); // expect sample split ...
                      },
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
