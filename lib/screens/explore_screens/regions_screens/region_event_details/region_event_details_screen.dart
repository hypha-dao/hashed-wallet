import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/components/region_event_detail_bottom_sheet.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/viewmodels/region_event_details_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class RegionEventDetailsScreen extends StatelessWidget {
  const RegionEventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegionEventModel event = ModalRoute.of(context)!.settings.arguments! as RegionEventModel;
    final double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_) => RegionEventDetailsBloc(event)..add(const OnRegionEventDetailsMounted()),
      child: BlocConsumer<RegionEventDetailsBloc, RegionEventDetailsState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final command = state.pageCommand;
          BlocProvider.of<RegionEventDetailsBloc>(context).add(const ClearRegionEventPageCommand());
          if (command is LaunchRegionMapsLocation) {
            final url = Platform.isIOS
                ? 'https://maps.apple.com/?q=${event.eventLocation.latitude},${event.eventLocation.longitude}'
                : 'https://www.google.com/maps/place/${event.eventLocation.latitude}+${event.eventLocation.longitude}/@${event.eventLocation.latitude},${event.eventLocation.longitude},17z';
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          } else if (command is ShowEditRegionEventButtons) {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
              ),
              context: context,
              builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<RegionEventDetailsBloc>(context), child: const RegionEventDetailBottomSheet()),
            );
          } else if (command is NavigateToRouteWithArguments) {
            NavigationService.of(context).navigateTo(command.route, command.arguments);
          } else if (command is NavigateToRoute) {
            NavigationService.of(context).navigateTo(command.route);
          } else if (command is ShowErrorMessage) {
            eventBus.fire(const ShowSnackBar('Operation fail try again.'));
          }
        },
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.loading:
              return const Scaffold(body: FullPageLoadingIndicator());
            case PageState.failure:
            case PageState.success:
              return Scaffold(
                body: ListView(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(defaultCardBorderRadius),
                          bottomRight: Radius.circular(defaultCardBorderRadius),
                        ),
                      ),
                      height: width * 0.8,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          FittedBox(
                            clipBehavior: Clip.hardEdge,
                            fit: BoxFit.cover,
                            child: CachedNetworkImage(
                              imageUrl: event.eventImage,
                              errorWidget: (_, __, ___) => const SizedBox.shrink(),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            right: 0,
                            child: Container(
                              height: 80,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.black54, Colors.transparent],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            right: 0,
                            child: AppBar(
                              backgroundColor: Colors.transparent,
                              actions: [
                                if (state.isEventCreatorAccount)
                                  IconButton(
                                      icon: const Icon(Icons.more_horiz),
                                      onPressed: () => BlocProvider.of<RegionEventDetailsBloc>(context)
                                          .add(const OnEditRegionEventButtonTapped()))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.eventName, style: Theme.of(context).textTheme.headline7),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, color: AppColors.green1, size: 30),
                              const SizedBox(width: 10),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('Start / ${event.formattedStartDate}',
                                    style: Theme.of(context).textTheme.subtitle2LowEmphasis),
                                Text('End / ${event.formattedEndDate}',
                                    style: Theme.of(context).textTheme.subtitle2LowEmphasis)
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const DividerJungle(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Details', style: Theme.of(context).textTheme.headline7),
                          const SizedBox(height: 10.0),
                          Text(event.eventAddress, style: Theme.of(context).textTheme.subtitle2),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: AppColors.green3),
                              const SizedBox(width: 11.0),
                              Flexible(
                                child: InkWell(
                                  onTap: () => BlocProvider.of<RegionEventDetailsBloc>(context)
                                      .add(const OnRegionMapsLinkTapped()),
                                  child: Text(
                                    'Open in maps',
                                    style: Theme.of(context).textTheme.subtitle3OpacityEmphasisGreen,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  event.eventDescription,
                                  style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: state.isBrowseView
                    ? null
                    : SafeArea(
                        minimum: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                        child: FlatButtonLong(
                          isLoading: state.pageState == PageState.loading,
                          title: state.isUserJoined ? "Leave event" : "I'm Attending!",
                          onPressed: () {
                            BlocProvider.of<RegionEventDetailsBloc>(context).add(
                              state.isUserJoined
                                  ? const OnLeaveRegionEventButtonPressed()
                                  : const OnJoinRegionEventButtonPressed(),
                            );
                          },
                        ),
                      ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
