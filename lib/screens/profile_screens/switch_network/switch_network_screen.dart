import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/chain_avatar.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/design/lib/hashed_body_widget.dart';
import 'package:hashed/domain-shared/event_bus/event_bus.dart';
import 'package:hashed/domain-shared/event_bus/events.dart';
import 'package:hashed/domain-shared/page_command.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/viewdata/network_data.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/viewmodels/switch_network_bloc.dart';

class SwitchNetworkScreen extends StatelessWidget {
  const SwitchNetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SwitchNetworkBloc()..add(const Initial()),
      child: BlocListener<SwitchNetworkBloc, SwitchNetworkState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          BlocProvider.of<SwitchNetworkBloc>(context).add(const ClearPageCommand());

          if (pageCommand is ShowErrorMessage) {
            eventBus.fire(ShowSnackBar.failure(pageCommand.message));
          } else if (pageCommand is ShowMessage) {
            eventBus.fire(ShowSnackBar.success(pageCommand.message));
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text("Network")),
          bottomNavigationBar: BlocBuilder<SwitchNetworkBloc, SwitchNetworkState>(
            buildWhen: (previous, current) =>
                previous.actionButtonLoading != current.actionButtonLoading ||
                previous.actionButtonEnabled != current.actionButtonEnabled,
            builder: (context, state) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: FlatButtonLong(
                    title: 'Switch',
                    onPressed: () {
                      BlocProvider.of<SwitchNetworkBloc>(context).add(OnSwitchTapped(state.selected!));
                    },
                    enabled: state.actionButtonEnabled,
                    isLoading: state.actionButtonLoading,
                  ),
                ),
              );
            },
          ),
          body: BlocBuilder<SwitchNetworkBloc, SwitchNetworkState>(
            builder: (context, state) {
              return HashedBodyWidget(
                pageState: state.pageState,
                success: (context) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Search...',
                        ),
                        onChanged: (value) {
                          BlocProvider.of<SwitchNetworkBloc>(context).add(OnSearchChanged(value));
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: state.filtered
                              .map((e) => e is NetworkData
                                  ? ListTile(
                                      onTap: () {
                                        BlocProvider.of<SwitchNetworkBloc>(context).add(OnNetworkSelected(e));
                                      },
                                      title: Text(e.name),
                                      leading: ClipOval(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(16), // Image radius
                                          child: ChainAvatar(
                                            name: e.name,
                                            size: 16,
                                            image: e.iconUrl,
                                          ),
                                        ),
                                      ),
                                      trailing: Radio<NetworkData>(
                                        value: e,
                                        groupValue: e == state.selected ? e : null,
                                        onChanged: (NetworkData? value) {
                                          BlocProvider.of<SwitchNetworkBloc>(context).add(OnNetworkSelected(e));
                                        },
                                      ))
                                  : e is NetworkDataHeader
                                      ? ListTile(title: Text(e.header))
                                      : const SizedBox.shrink())
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
