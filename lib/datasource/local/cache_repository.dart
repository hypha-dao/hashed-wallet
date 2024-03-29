import 'package:hashed/datasource/local/member_model_cache_item.dart';
import 'package:hive/hive.dart';

const String _membersBox = 'membersBox001';

// Cache Repo
class CacheRepository {
  const CacheRepository();

  bool _boxIsClosed(Box box) => !box.isOpen;

  /// Deletes all currently open boxes from disk.
  Future<void> clear() => Hive.deleteFromDisk();

  Future<MemberModelCacheItem?> getMemberCacheItem(String account) async {
    final box = await Hive.openBox<MemberModelCacheItem>(_membersBox);
    if (_boxIsClosed(box)) {
      return null;
    }
    return box.get(account);
  }

  Future<void> saveMemberCacheItem(String account, MemberModelCacheItem memberModelCacheItem) async {
    final box = await Hive.openBox<MemberModelCacheItem>(_membersBox);
    if (_boxIsClosed(box)) {
      return;
    }
    await box.put(account, memberModelCacheItem);
  }
}
