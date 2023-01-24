import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/chain_avatar.dart';
import 'package:hashed/datasource/local/account_service.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/screens/wallet/interactor/viewmodels/wallet_bloc.dart';
import 'package:hashed/utils/short_string.dart';

class WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WalletAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        return AppBar(
          leadingWidth: 60,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ChainAvatar(name: "", size: 50, image: state.logoUrl),
          ),
          title: InkWell(
            onTap: () => _copyToClipboard(accountService.currentAccount.address),
            child: Row(
              children: [
                Text(
                  accountService.currentAccount.address.shorter,
                  //style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Icon(Icons.copy_all_rounded),
              ],
            ),
          ),
          actions: [],
        );
      },
    );
  }

  Future<void> _copyToClipboard(String words) async {
    await Clipboard.setData(ClipboardData(text: words));
    eventBus.fire(const ShowSnackBar.success('Copied Account Address'));
  }
}
