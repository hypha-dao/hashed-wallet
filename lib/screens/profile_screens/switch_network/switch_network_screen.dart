import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/design/lib/hashed_body_widget.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/viewdata/network_data.dart';
import 'package:hashed/screens/profile_screens/switch_network/interactor/viewmodels/switch_network_bloc.dart';

class SwitchNetworkScreen extends StatelessWidget {
  const SwitchNetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Network")),
      body: BlocProvider(
        create: (context) => SwitchNetworkBloc()..add(const Initial()),
        child: BlocBuilder<SwitchNetworkBloc, SwitchNetworkState>(
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
                    const SizedBox(height: 8),
                    ListView(
                      shrinkWrap: true,
                      children: state.filtered
                          .map((e) => ListTile(
                              onTap: () {
                                BlocProvider.of<SwitchNetworkBloc>(context).add(OnNetworkSelected(e));
                              },
                              title: Text(e.name),
                              leading: ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(14), // Image radius
                                  child: Image.network(e.iconUrl, fit: BoxFit.cover),
                                ),
                              ),
                              trailing: Radio<NetworkData>(
                                value: e,
                                groupValue: e == state.selected ? e : null,
                                onChanged: (NetworkData? value) {
                                  BlocProvider.of<SwitchNetworkBloc>(context).add(OnNetworkSelected(e));
                                },
                              )))
                          .toList(),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
