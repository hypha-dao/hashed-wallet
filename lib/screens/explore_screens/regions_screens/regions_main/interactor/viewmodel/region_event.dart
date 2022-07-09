part of 'region_bloc.dart';

abstract class RegionEvent extends Equatable {
  const RegionEvent();

  @override
  List<Object?> get props => [];
}

class OnRegionMounted extends RegionEvent {
  const OnRegionMounted();

  @override
  String toString() => 'OnRegionMounted';
}

class OnShareRegionPressed extends RegionEvent {
  const OnShareRegionPressed();

  @override
  String toString() => 'OnShareRegionPressed';
}

class OnJoinRegionButtonPressed extends RegionEvent {
  const OnJoinRegionButtonPressed();

  @override
  String toString() => 'OnJoinRegionButtonPressed';
}

class OnEditRegionImageButtonPressed extends RegionEvent {
  const OnEditRegionImageButtonPressed();

  @override
  String toString() => 'OnEditRegionImageButtonPressed';
}

class OnEditRegionDescriptionButtonPressed extends RegionEvent {
  const OnEditRegionDescriptionButtonPressed();

  @override
  String toString() => 'OnEditRegionDescriptionButtonPressed';
}

class OnLeaveRegionButtonPressed extends RegionEvent {
  const OnLeaveRegionButtonPressed();

  @override
  String toString() => 'OnLeaveRegionButtonPressed';
}

class OnAddEventButtonPressed extends RegionEvent {
  const OnAddEventButtonPressed();

  @override
  String toString() => 'OnAddEventButtonPressed';
}

class ClearRegionPageCommand extends RegionEvent {
  const ClearRegionPageCommand();

  @override
  String toString() => 'ClearRegionPageCommand';
}
