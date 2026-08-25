import '../data/profile_model.dart';

abstract class ProfileRepository {
  Future<Profile?> getProfile(String userId);
}
