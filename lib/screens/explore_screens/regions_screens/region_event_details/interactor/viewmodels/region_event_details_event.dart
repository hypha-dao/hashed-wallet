part of 'region_event_details_bloc.dart';

abstract class RegionEventDetailsEvent extends Equatable {
  const RegionEventDetailsEvent();

  @override
  List<Object> get props => [];
}

class OnRegionEventDetailsMounted extends RegionEventDetailsEvent {
  const OnRegionEventDetailsMounted();

  @override
  String toString() => 'OnRegionEventDetailsMounted';
}

class OnRegionMapsLinkTapped extends RegionEventDetailsEvent {
  const OnRegionMapsLinkTapped();

  @override
  String toString() => 'OnRegionMapsLinkTapped';
}

class OnJoinRegionEventButtonPressed extends RegionEventDetailsEvent {
  const OnJoinRegionEventButtonPressed();

  @override
  String toString() => 'OnJoinRegionEventButtonPressed';
}

class OnLeaveRegionEventButtonPressed extends RegionEventDetailsEvent {
  const OnLeaveRegionEventButtonPressed();

  @override
  String toString() => 'OnLeaveRegionEventButtonPressed';
}

class ClearRegionEventPageCommand extends RegionEventDetailsEvent {
  const ClearRegionEventPageCommand();

  @override
  String toString() => 'ClearRegionEventPageCommand';
}

class OnEditRegionEventButtonTapped extends RegionEventDetailsEvent {
  const OnEditRegionEventButtonTapped();

  @override
  String toString() => 'OnEditRegionEventButtonTapped';
}

class OnEditEventImageTapped extends RegionEventDetailsEvent {
  const OnEditEventImageTapped();

  @override
  String toString() => 'OnEditEventImageTapped';
}

class OnEditEventNameAndDescriptionTapped extends RegionEventDetailsEvent {
  const OnEditEventNameAndDescriptionTapped();

  @override
  String toString() => 'OnEditEventNameAndDescriptionTapped';
}

class OnEditEventDateAndTimeTapped extends RegionEventDetailsEvent {
  const OnEditEventDateAndTimeTapped();

  @override
  String toString() => 'OnEditEventDateAndTimeTapped';
}

class OnEditEventLocationTapped extends RegionEventDetailsEvent {
  const OnEditEventLocationTapped();

  @override
  String toString() => 'OnEditEventLocationTapped';
}

class OnDeleteEventTapped extends RegionEventDetailsEvent {
  const OnDeleteEventTapped();

  @override
  String toString() => 'OnDeleteEventTapped';
}
