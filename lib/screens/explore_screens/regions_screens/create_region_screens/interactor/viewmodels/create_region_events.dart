part of 'create_region_bloc.dart';

abstract class CreateRegionEvent extends Equatable {
  const CreateRegionEvent();

  @override
  List<Object?> get props => [];
}

class ClearCreateRegionPageCommand extends CreateRegionEvent {
  const ClearCreateRegionPageCommand();

  @override
  String toString() => 'clearCreateRegionPageCommand ';
}

class OnUpdateMapLocation extends CreateRegionEvent {
  final Place place;

  const OnUpdateMapLocation(this.place);

  @override
  String toString() => 'OnUpdateMapLocation { Place: $place}';
}

class OnPickImage extends CreateRegionEvent {
  const OnPickImage();

  @override
  String toString() => 'OnImageUpload';
}

class OnNextTapped extends CreateRegionEvent {
  const OnNextTapped();

  @override
  String toString() => 'OnNextTapped';
}

class OnPickImageNextTapped extends CreateRegionEvent {
  const OnPickImageNextTapped();

  @override
  String toString() => 'OnNextTapped';
}

class OnBackPressed extends CreateRegionEvent {
  const OnBackPressed();

  @override
  String toString() => 'OnBackPressed';
}

class OnRegionNameChange extends CreateRegionEvent {
  final String regionName;

  const OnRegionNameChange(this.regionName);

  @override
  String toString() => 'OnRegionNameChange { regionName: $regionName}';
}

class OnRegionDescriptionChange extends CreateRegionEvent {
  final String regionDescription;

  const OnRegionDescriptionChange(this.regionDescription);

  @override
  String toString() => 'OnRegionDescriptionChange { regionDescription: $regionDescription}';
}

class OnRegionIdChange extends CreateRegionEvent {
  final String regionId;

  const OnRegionIdChange(this.regionId);

  @override
  String toString() => 'OnRegionIdChange { regionId: $regionId}';
}

class OnRegionNameNextTapped extends CreateRegionEvent {
  const OnRegionNameNextTapped();

  @override
  String toString() => 'OnRegionNameNextTapped';
}

class OnConfirmCreateRegionTapped extends CreateRegionEvent {
  const OnConfirmCreateRegionTapped();

  @override
  String toString() => 'onCreateRegionTapped';
}

class OnPublishRegionTapped extends CreateRegionEvent {
  const OnPublishRegionTapped();

  @override
  String toString() => 'onPublishRegionTapped';
}
