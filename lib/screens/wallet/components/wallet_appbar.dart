import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/navigation/navigation_service.dart';
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
          //ignore: avoid_redundant_argument_values

          actions: [
            const SizedBox(width: horizontalEdgePadding + 36),
            Expanded(child: Image.asset('assets/images/appbar/hashed_logo.png', fit: BoxFit.fitHeight)),
            IconButton(
              splashRadius: 26,
              icon: SvgPicture.asset('assets/images/wallet/app_bar/scan_qr_code_icon.svg', height: 36),
              onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
            ),
            const SizedBox(width: horizontalEdgePadding),
          ],
        );
      },
    );
  }
}
