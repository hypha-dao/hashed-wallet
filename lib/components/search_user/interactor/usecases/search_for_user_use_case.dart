import 'package:async/async.dart';
import 'package:hashed/datasource/remote/api/members_repository.dart';
import 'package:hashed/datasource/remote/model/profile_model.dart';

class SearchForMemberUseCase {
  Future<List<Result<List<ProfileModel>>>> run(String searchQuery) {
    final futures = [
      MembersRepository().getFullNameSearchMembers(searchQuery),
    ];
    return Future.wait(futures);
  }
}
