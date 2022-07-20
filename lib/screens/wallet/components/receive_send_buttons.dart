import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/local/flutter_js/js_init.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

// ignore: must_be_immutable
class ReceiveSendButtons extends StatelessWidget {
  late JSInit? initObj;
  ReceiveSendButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TokenBalancesBloc, TokenBalancesState>(
      buildWhen: (previous, current) => previous.selectedIndex != current.selectedIndex,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: MaterialButton(
                  padding: const EdgeInsets.only(top: 14, bottom: 14),
                  onPressed: () => NavigationService.of(context).navigateTo(Routes.transfer),
                  // color: tokenColor ?? AppColors.green1,
                  // disabledColor: tokenColor ?? AppColors.green1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Center(
                    child: Wrap(
                      children: [
                        const Icon(Icons.arrow_upward),
                        Container(
                          padding: const EdgeInsets.only(left: 4, top: 4),
                          child: Text(context.loc.walletSendButtonTitle, style: Theme.of(context).textTheme.button),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: MaterialButton(
                  padding: const EdgeInsets.only(top: 14, bottom: 14),
                  onPressed: () async {
                    // testing substrate service - leave this for now
                    print("init js");

                    initObj = JSInit();

                    print("init js - init");

                    await initObj!.init();

                    // print("substrate function test");

                    // final service = SubstrateService();
                    // final keyRing = Keyring();
                    // await service.init(keyRing, onInitiated: () => {print("initiated.")});

                    // final controller = service.webView!.web?.webViewController;

                    // final res1 = await controller?.evaluateJavascript(source: '1 + 4');
                    // print(res1.runtimeType); // int
                    // print(res1);

                    // final hashedEndpoint = "wss://n1.hashed.systems";

                    // print("Connecting Endpoint");
                    // final res = await service.webView!.connectEndpoint(hashedEndpoint);
                    // print("Connecting Endpoint done.");

                    // print(res);

                    // print("Getting constants");

                    // final consts = await service.setting.apiConsts();

                    // print("CONSTS");

                    // print(consts);
                    // // NavigationService.of(context).navigateTo(Routes.receiveEnterData)
                  },
                  // color: tokenColor ?? AppColors.green1,
                  // disabledColor: tokenColor ?? AppColors.green1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Wrap(
                      children: [
                        const Icon(Icons.arrow_downward),
                        Container(
                          padding: const EdgeInsets.only(left: 4, top: 4),
                          child: Text(context.loc.walletReceiveButtonTitle, style: Theme.of(context).textTheme.button),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
