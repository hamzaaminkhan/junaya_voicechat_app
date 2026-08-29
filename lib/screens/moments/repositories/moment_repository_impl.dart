import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_repository.dart';


class MomentRepositoryImpl implements MomentRepository {

  final List<Moment> _cache = [];


  @override
  Future<List<Moment>> getMoments() async {
    return List.unmodifiable(_cache);
  }


  @override
  Future<Moment?> getMoment(String id) async {

    try {

      return _cache.firstWhere(
            (moment)=>moment.id == id,
      );

    } catch (_) {

      return null;

    }
  }


  @override
  Future<Moment> createMoment({
    required Moment moment,
    required List<String> mediaPaths,
  }) async {

    _cache.insert(
      0,
      moment,
    );

    return moment;
  }


  @override
  Future<Moment> updateMoment(
      Moment moment,
      ) async {

    final index = _cache.indexWhere(
          (item)=>item.id == moment.id,
    );


    if(index != -1){

      _cache[index] = moment;

    }


    return moment;
  }


  @override
  Future<Moment> addMedia({
    required Moment moment,
    required List<String> mediaPaths,
  }) async {

    return moment;
  }


  @override
  Future<Moment> removeMedia({
    required Moment moment,
    required String mediaId,
  }) async {

    return moment;
  }


  @override
  Future<void> deleteMoment(
      String id,
      ) async {

    _cache.removeWhere(
          (moment)=>moment.id == id,
    );

  }


  @override
  Future<Moment> toggleLike(
      Moment moment,
      ) async {

    return moment;
  }


  @override
  Future<Moment> addReaction({
    required Moment moment,
    required String userId,
    required String emoji,
  }) async {

    return moment;
  }


  @override
  Future<Moment> removeReaction({
    required Moment moment,
    required String userId,
    required String emoji,
  }) async {

    return moment;
  }


  @override
  Future<Moment> incrementViews(
      String id,
      ) async {

    return await getMoment(id) ??
        (throw Exception("Moment not found"));

  }


  @override
  Future<Moment> toggleSave(
      Moment moment,
      ) async {

    return moment;
  }


  @override
  Future<Moment> incrementShares(
      String id,
      ) async {

    return await getMoment(id) ??
        (throw Exception("Moment not found"));

  }


  @override
  Future<List<Moment>> searchMoments(
      String query,
      ) async {

    final value = query.toLowerCase();


    return _cache.where((moment){

      return moment.caption
          .toLowerCase()
          .contains(value);

    }).toList();

  }


  @override
  Future<List<Moment>> getUserMoments(
      String userId,
      ) async {

    return _cache;

  }


  @override
  Future<List<Moment>> getMomentsPage({
    required int limit,
    String? cursor,
  }) async {

    return _cache
        .take(limit)
        .toList();

  }


  @override
  Future<void> clearAll() async {

    _cache.clear();

  }

}