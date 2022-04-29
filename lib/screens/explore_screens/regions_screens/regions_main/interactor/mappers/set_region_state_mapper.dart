import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/datasource/remote/model/firebase_models/firebase_region_model.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';

class SetRegionStateMapper extends StateMapper {
  RegionState mapResultToState(RegionState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      final List goodResults = results.where((r) => r.isValue).map((v) => v.asValue!.value).toList();
      final RegionModel? region = goodResults.whereType<RegionModel>().firstOrNull;
      final FirebaseRegion? firebaseRegion = goodResults.whereType<FirebaseRegion>().firstOrNull;

      return currentState.copyWith(
        pageState: PageState.success,
        isBrowseView: false,
        region: firebaseRegion != null ? region?.addImageUrlToModel(firebaseRegion.imageUrl) : region,
      );
    }
  }
}