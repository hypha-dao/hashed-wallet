import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashed/components/flat_button_long.dart';
import 'package:hashed/components/text_form_field_custom.dart';
import 'package:hashed/domain-shared/ui_constants.dart';
import 'package:hashed/screens/authentication/sign_up/viewmodels/signup_bloc.dart';
import 'package:hashed/utils/build_context_extension.dart';
import 'package:hashed/utils/string_extension.dart';

class CreateDisplayNameScreen extends StatefulWidget {
  const CreateDisplayNameScreen({super.key});

  @override
  _CreateDisplayNameStateScreen createState() => _CreateDisplayNameStateScreen();
}

class _CreateDisplayNameStateScreen extends State<CreateDisplayNameScreen> {
  late SignupBloc _signupBloc;
  final _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    _keyController.text = _signupBloc.state.displayName ?? '';
    _keyController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _navigateBack,
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return Scaffold(
            // From invite link, there isn't a screen below the stack thus no implicit back arrow
            appBar: AppBar(
              title: const Text("Choose your name"),
              leading: BackButton(onPressed: _navigateBack),
            ),
            body: SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormFieldCustom(
                    // ignore: avoid_redundant_argument_values
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    labelText: "Name",
                    onFieldSubmitted: (_) => _onNextPressed(),
                    maxLength: 36,
                    controller: _keyController,
                    validator: (value) {
                      if (value.isNullOrEmpty) {
                        return context.loc.signUpNameCannotBeEmpty;
                      }
                      return null;
                    },
                  ),
                  const Expanded(child: Text("Enter a name for this account")),
                  FlatButtonLong(onPressed: _onNextPressed(), title: "Next"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  VoidCallback? _onNextPressed() => _keyController.text.isNotEmpty
      ? () {
          FocusScope.of(context).unfocus();
          _signupBloc.add(DisplayNameOnNextTapped(_keyController.text));
        }
      : null;

  Future<bool> _navigateBack() {
    _signupBloc.add(const OnBackPressed());
    return Future.value(false);
  }
}
