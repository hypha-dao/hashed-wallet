import 'package:seeds/datasource/remote/api/google_places_repository.dart';
import 'package:seeds/datasource/remote/model/google_places_models/place_details_model.dart';
import 'package:seeds/datasource/remote/model/google_places_models/prediction_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/utils/uuid.dart';

class GetPlacesAutocompleteUseCase extends InputUseCase<PlacesAutocompleteResponse, _Input> {
  static _Input input(
    String input, {
    String? sessionToken,
    num? offset,
    Location? origin,
    Location? location,
    num radius = 200000, // 200 km
    String? language,
    List<String> types = const [],
    List<Component> components = const [],
    bool strictbounds = false,
    String? region,
  }) =>
      _Input(
        input,
        sessionToken: sessionToken,
        offset: offset,
        origin: origin,
        location: location,
        radius: radius,
        language: language,
        types: types,
        components: components,
        strictbounds: strictbounds,
        region: region,
      );

  @override
  Future<Result<PlacesAutocompleteResponse>> run(_Input input) async {
    return GoogleMapsPlacesRepository().autocomplete(
      input.input,
      sessionToken: Uuid().generateV4(),
      offset: input.offset,
      origin: input.origin,
      location: input.location,
      radius: input.radius,
      language: input.language,
      types: input.types,
      components: input.components,
      strictbounds: input.strictbounds,
      region: input.region,
    );
  }
}

class _Input {
  final String input;
  final String? sessionToken;
  final num? offset;
  final Location? origin;
  final Location? location;
  final num radius;
  final String? language;
  final List<String> types;
  final List<Component> components;
  final bool strictbounds;
  final String? region;

  const _Input(
    this.input, {
    this.sessionToken,
    this.offset,
    this.origin,
    this.location,
    required this.radius,
    this.language,
    required this.types,
    required this.components,
    required this.strictbounds,
    this.region,
  });
}
