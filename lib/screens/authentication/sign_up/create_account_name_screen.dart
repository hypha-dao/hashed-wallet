import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/global_error.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/page_commands.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/signup_bloc.dart';

class CreateAccountNameScreen extends StatefulWidget {
  const CreateAccountNameScreen({super.key});

  @override
  _CreateAccountNameStateScreen createState() => _CreateAccountNameStateScreen();
}

const wordsTextConstant = """
You can use these secret words to recover your account.

No one but you has these words so save them somewhere where you can find them again.

Either copy paste them somewhere safe, or write them down on a piece of paper.
""";

class _CreateAccountNameStateScreen extends State<CreateAccountNameScreen> {
  late SignupBloc _signupBloc;
  final TextEditingController _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    if (_signupBloc.state.accountName != null) {
      _keyController.text = _signupBloc.state.accountName!;
    }
  }

  void _copyToClipboard(String words) {
    print("copy");
    Clipboard.setData(ClipboardData(text: words));
    eventBus.fire(const ShowSnackBar.success('Copied Secret Words'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _navigateBack,
      child: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.pageState == PageState.initial && state.pageCommand is OnAccountNameGenerated) {
            _keyController.text = state.accountName ?? _keyController.text;
            _signupBloc.add(OnAccountNameChanged(state.accountName!));
          }

          if (state.pageState == PageState.failure) {
            eventBus.fire(ShowSnackBar(
                state.error?.localizedDescription(context) ?? GlobalError.unknown.localizedDescription(context)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            // From invite link, there isn't a screen below the stack thus no implicit back arrow
            appBar: AppBar(
              title: const Text("Save your secret words"),
              leading: BackButton(onPressed: _navigateBack),
            ),
            body: SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () => _copyToClipboard(state.accountName),
                        child: IgnorePointer(
                          child: TextFormField(
                            initialValue:
                                "this is the 12 input words and there is way more lets see if we line break yes we do and there is more so this is goo",
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: Theme.of(context).textTheme.subtitle1,
                            decoration: InputDecoration(
                              suffixStyle: Theme.of(context).textTheme.subtitle2,
                              suffixIcon: const Icon(Icons.copy_all),
                              contentPadding: const EdgeInsets.all(16.0),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Expanded(
                        child: Text(wordsTextConstant),
                      ),
                      FlatButtonLong(
                        title: "Create Account",
                        onPressed: state.isNextButtonActive
                            ? () {
                                FocusScope.of(context).unfocus();
                                _signupBloc.add(OnCreateAccountTapped(_keyController.text));
                              }
                            : null,
                      ),
                    ],
                  ),
                  if (state.pageState == PageState.loading) const FullPageLoadingIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _navigateBack() {
    _signupBloc.add(const OnBackPressed());
    return Future.value(false);
  }
}
