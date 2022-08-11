import 'package:flutter/widgets.dart';
import 'package:hashed/utils/build_context_extension.dart';

enum GlobalError {
  unknown;

  String localizedDescription(BuildContext context) {
    switch (this) {
      case GlobalError.unknown:
        return context.loc.globalUnknownError;
    }
  }
}
