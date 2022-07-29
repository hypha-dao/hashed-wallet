import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/authentication/create_nickname/viewmodels/create_nickname_bloc.dart';

class CreateNicknameScreen extends StatelessWidget {
  const CreateNicknameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _arguments = ModalRoute.of(context)!.settings.arguments as List<Object?>?;
    final ProfileModel? _profileModel = _arguments!.first as ProfileModel?;
    final _authData = _arguments.last as AuthDataModel?;

    return Scaffold(
      appBar: AppBar(title: const Text("Create nickname")),
      body: BlocProvider(
        create: (_) => CreateNicknameBloc(),
        child: BlocListener<CreateNicknameBloc, CreateNicknameState>(
          listenWhen: (previous, current) => current.continueToAccount != previous.continueToAccount,
          listener: (context, state) {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(OnImportAccount(account: _profileModel!.account, authData: _authData!));
          },
          child: Builder(
            builder: (context) {
              return SafeArea(
                minimum: const EdgeInsets.all(horizontalEdgePadding),
                child: Form(
                  child: Column(
                    children: [
                      TextFormFieldCustom(
                        labelText: 'Nickname (Optional)',
                        onChanged: (String value) {
                          BlocProvider.of<CreateNicknameBloc>(context).add(OnNicknameChange(nickname: value));
                        },
                      ),
                      const Spacer(),
                      BlocBuilder<CreateNicknameBloc, CreateNicknameState>(
                        buildWhen: (previous, current) {
                          return previous.isButtonLoading != current.isButtonLoading;
                        },
                        builder: (context, state) {
                          return FlatButtonLong(
                            isLoading: state.isButtonLoading,
                            title: "Next (2/2)",
                            onPressed: () {
                              BlocProvider.of<CreateNicknameBloc>(context).add(const OnNextTapped());
                            },
                          );
                        },
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