import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/screens/wallet/interactor/viewmodels/wallet_bloc.dart';

class WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WalletAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        return AppBar(
          actions: [
            const SizedBox(width: horizontalEdgePadding + 36),
            Expanded(child: Image.asset('assets/images/appbar/hashed_logo.png', fit: BoxFit.fitHeight)),
            const SizedBox(width: horizontalEdgePadding),
          ],
        );
      },
    );
  }
}
