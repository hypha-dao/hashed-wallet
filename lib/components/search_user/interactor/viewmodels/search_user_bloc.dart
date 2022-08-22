import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hashed/components/search_user/interactor/usecases/search_for_user_use_case.dart';
import 'package:hashed/datasource/local/models/account.dart';
import 'package:hashed/domain-shared/page_state.dart';
import 'package:rxdart/rxdart.dart';

part 'search_user_event.dart';
part 'search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final int _minTextLengthBeforeValidSearch = 2;

  SearchUserBloc() : super(SearchUserState.initial()) {
    on<OnSearchChange>(_onSearchChange, transformer: _transformEvents);
    on<ClearIconTapped>(_clearIconTapped);
  }

  /// Debounce to avoid making search network calls each time the user types
  /// switchMap: To remove the previous event. Every time a new Stream is created, the previous Stream is discarded.
  Stream<OnSearchChange> _transformEvents(
      Stream<OnSearchChange> events, Stream<OnSearchChange> Function(OnSearchChange) transitionFn) {
    return events.debounceTime(const Duration(milliseconds: 300)).switchMap(transitionFn);
  }

  Future<void> _onSearchChange(OnSearchChange event, Emitter<SearchUserState> emit) async {
    emit(state.copyWith(pageState: PageState.loading, showClearIcon: event.searchQuery.isNotEmpty));
    if (event.searchQuery.length > _minTextLengthBeforeValidSearch) {
      final result = await SearchForMemberUseCase().run(event.searchQuery);

      if (result.isValue) {
        emit(state.copyWith(
          pageState: PageState.success,
          account: result.asValue!.value,
        ));
      } else {
        emit(state.copyWith(
          pageState: PageState.failure,
        ));
      }
    } else {
      emit(state.copyWith(pageState: PageState.success));
    }
  }

  void _clearIconTapped(ClearIconTapped event, Emitter<SearchUserState> emit) {
    emit(SearchUserState.initial());
  }
}
