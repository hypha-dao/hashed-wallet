import 'package:flutter/material.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/navigation/navigation_service.dart';
import 'package:hashed/utils/build_context_extension.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text(context.loc.loginFirstTimeHere, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    FlatButtonLong(
                      onPressed: () => NavigationService.of(context).navigateTo(Routes.signup),
                      title: "Create Account",
                    ),
                    const SizedBox(height: 40),
                    Text("Already have an account?", style: Theme.of(context).textTheme.titleSmall),
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
