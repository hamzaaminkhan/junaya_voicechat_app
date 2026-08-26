import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/media_upload_service.dart';

import 'media_uploader_provider.dart';
import 'moments_provider.dart';


final mediaUploadServiceProvider =
Provider<MediaUploadService>((ref){

  return MediaUploadService(

    uploader:
    ref.watch(
      mediaUploaderProvider,
    ),

    repository:
    ref.watch(
      momentRepositoryProvider,
    ),

  );

});