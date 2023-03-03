import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/screens/wallet/interactor/viewmodels/member_bloc.dart';
import 'package:hashed/utils/read_times_tamp.dart';
import 'package:hashed/utils/string_extension.dart';

class TransactionInfoRow extends StatelessWidget {
  final String profileAccount;
  final DateTime timestamp;
  final String amount;
  final bool incoming;
  final GestureTapCallback onTap;

  const TransactionInfoRow({
    super.key,
    required this.amount,
    required this.onTap,
    required this.profileAccount,
    required this.timestamp,
    required this.incoming,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MemberBloc>(
      create: (_) => MemberBloc(profileAccount)..add(const OnLoadMemberData()),
      child: BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          return InkWell(
            onTap: onTap,
            child: Ink(
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 16, left: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  state.localizedDisplayName(context),
                                  style: Theme.of(context).textTheme.labelLarge,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 40),
                              if (incoming) const Text('+') else const Text('-'),
                              const SizedBox(width: 4),
                              Text(amount.seedsFormatted, style: Theme.of(context).textTheme.labelLarge),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: Text(timesTampToTimeAgo(timestamp))),
                              Text(amount.symbolFromAmount)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
