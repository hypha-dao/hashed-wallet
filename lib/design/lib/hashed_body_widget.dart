import 'package:flutter/material.dart';
import 'package:hashed/domain-shared/page_state.dart';

typedef SuccessWidgetBuilder = Widget Function(BuildContext context);

/// Generic Widget to be used mostly inside a Scaffold body
/// You must pass at least a page state and a success widget
class HashedBodyWidget extends StatelessWidget {
  final PageState pageState;
  final SuccessWidgetBuilder success;
  final Widget? initial;
  final Widget? loading;
  final Widget? failure;
  final double minBottomSpacing;

  const HashedBodyWidget({
    super.key,
    required this.pageState,
    required this.success,
    this.initial,
    this.loading,
    this.failure,
    this.minBottomSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return _bodyContent(context);
  }

  Widget _bodyContent(BuildContext context) {
    switch (pageState) {
      case PageState.initial:
        return initial ?? const SizedBox.shrink();
      case PageState.loading:
        return loading ?? const Center(child: CircularProgressIndicator.adaptive());
      case PageState.failure:
        return failure ?? const SizedBox.shrink();
      case PageState.success:
        return GestureDetector(
          child: success(context),
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        );
    }
  }
}
