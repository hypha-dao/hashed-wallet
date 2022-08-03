// import 'package:seeds/datasource/local/models/auth_data_model.dart';
// import 'package:seeds/datasource/remote/model/profile_model.dart';
// import 'package:seeds/domain-shared/page_command.dart';
// import 'package:seeds/domain-shared/result_to_state_mapper.dart';
// import 'package:seeds/navigation/navigation_service.dart';
// import 'package:seeds/screens/authentication/import_key/interactor/viewmodels/import_key_bloc.dart';

// class ImportKeyStateMapper extends StateMapper {
//   ImportKeyState mapResultsToState({
//     required ImportKeyState currentState,
//     required AuthDataModel authData,
//     required List<Result> results,
//     AuthDataModel? alternateAuthData,
//     List<Result> alternateResults = const [],
//   }) {
//     final List<Result> goodResults = results.isNotEmpty ? results : alternateResults;
//     final AuthDataModel? goodAuthData = results.isNotEmpty ? authData : alternateAuthData;
//     // No account found. Show error
//     if (goodResults.isEmpty) {
//       return currentState.copyWith(
//           enableButton: false,
//           isButtonLoading: false,
//           error: "No Account Found",
//           pageCommand: ShowErrorMessage("Error Loading Account"));
//     }

//     // Accounts found, but errors fetching data happened.
//     if (areAllResultsError(goodResults)) {
//       return currentState.copyWith(
//           enableButton: false,
//           isButtonLoading: false,
//           error: "Unable To Load Account",
//           pageCommand: ShowErrorMessage("Error Loading Account"));
//     } else {
//       final List<ProfileModel> profiles = goodResults
//           .where((Result result) => result.isValue)
//           .map((Result result) => result.asValue!.value as ProfileModel)
//           .toList();

//       return currentState.copyWith(
//           isButtonLoading: false,
//           accounts: profiles,
//           authData: goodAuthData,
//           pageCommand:
//               NavigateToRouteWithArguments(route: Routes.createNickname, arguments: [profiles.first, goodAuthData]));
//     }
//   }
// }
