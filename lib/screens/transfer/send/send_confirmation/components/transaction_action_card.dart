import 'package:flutter/material.dart';
import 'package:hashed/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_bloc.dart';
import 'package:hashed/utils/cap_utils.dart';

class TransactionActionCard extends StatelessWidget {
  final SendTransaction action;

  const TransactionActionCard(this.action, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      // ignore: use_decorated_box
      child: Container(
        decoration: const BoxDecoration(
          // border: Border.all(color: AppColors.grey1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('transfer'.inCaps),
                  Text('balances', style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
              const Divider(),
              Column(
                children: [
                  for (final i in action.data.entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(i.key.inCaps),
                          const SizedBox(width: 4),
                          Flexible(child: Text('${i.value}', style: Theme.of(context).textTheme.subtitle2)),
                        ],
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
