import '../data/like_model.dart';

abstract class LikeRepository {
  Future<List<Like>> getLikes(String momentId);
  Future<Like> toggleLike(Like like);
}
