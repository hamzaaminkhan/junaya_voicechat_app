import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_draft_model.dart';
import 'package:junaya_voicechat_app/screens/moments/storage/draft_storage.dart';


final momentDraftStorageProvider =
Provider<MomentDraftStorage>((ref) {
  return MomentDraftStorage();
});

final momentDraftProvider =
AsyncNotifierProvider<
    MomentDraftNotifier,
    MomentDraft?>(
  MomentDraftNotifier.new,
);

class MomentDraftNotifier
    extends AsyncNotifier<MomentDraft?> {
  late final MomentDraftStorage _storage;

  @override
  Future<MomentDraft?> build() async {
    _storage =
        ref.watch(momentDraftStorageProvider);

    return _storage.load();
  }

  Future<void> save(
      MomentDraft draft,
      ) async {
    state =
    const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _storage.save(draft);
      return draft;
    });
  }

  Future<void> clear() async {
    await _storage.clear();

    state =
    const AsyncData(null);
  }

  Future<MomentDraft?> reload() async {
    final draft =
    await _storage.load();

    state =
        AsyncData(draft);

    return draft;
  }

  Future<bool> exists() {
    return _storage.exists();
  }
}