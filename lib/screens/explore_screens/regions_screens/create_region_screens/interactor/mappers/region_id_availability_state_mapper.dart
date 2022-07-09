import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/components/authentication_status.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';

class RegionIdAvailabilityStateMapper extends StateMapper {
  CreateRegionState mapResultToState(CreateRegionState currentState, Result<RegionModel?> result) {
    if (result.isError) {
      return currentState.copyWith(
          pageState: PageState.success, pageCommand: ShowErrorMessage("Error with id validation"));
    } else {
      if (result.asValue?.value == null) {
        return currentState.copyWith(regionIdValidationStatus: RegionIdStatusIcon.valid);
      } else {
        return currentState.copyWith(
          regionIdValidationStatus: RegionIdStatusIcon.invalid,
          regionIdErrorMessage: "Region Id is already taken, please provide a new one",
        );
      }
    }
  }
}
