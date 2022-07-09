import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class EditRegionEventEventUseCase extends InputUseCase<String, EditRegionEventInput> {
  final FirebaseDatabaseRegionsRepository _firebaseDatabaseRegionsRepository = FirebaseDatabaseRegionsRepository();

  @override
  Future<Result<String>> run(EditRegionEventInput input) async {
    final Result<String> editRegionEventResult = await _firebaseDatabaseRegionsRepository.editRegionEvent(
        eventId: input.event.id,
        eventName: input.eventName,
        eventDescription: input.eventDescription,
        eventImage: input.imageUrl,
        place: input.newPlace,
        eventStartTime: input.eventStartTime,
        eventEndTime: input.eventEndTime);

    return editRegionEventResult;
  }
}

class EditRegionEventInput {
  final String? eventName;
  final String? eventDescription;
  final String? imageUrl;
  final Place? newPlace;
  final DateTime? eventStartTime;
  final DateTime? eventEndTime;
  final RegionEventModel event;

  EditRegionEventInput({
    this.eventName,
    this.eventDescription,
    this.imageUrl,
    this.newPlace,
    this.eventStartTime,
    this.eventEndTime,
    required this.event,
  });
}
