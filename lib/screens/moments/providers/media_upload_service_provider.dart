import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/media_upload_service.dart';

import 'media_uploader_provider.dart';
import 'moments_provider.dart';





// =====================================================
// MEDIA UPLOAD SERVICE PROVIDER
// =====================================================
//
// MediaUploader
//       |
//       v
// MediaUploadService
//       |
//       v
// MomentRepository
//
// =====================================================


final mediaUploadServiceProvider =

Provider<MediaUploadService>((ref) {



  final uploader =

  ref.watch(

    mediaUploaderProvider,

  );





  final repository =

  ref.watch(

    momentRepositoryProvider,

  );






  return MediaUploadService(

    uploader:

    uploader,



    repository:

    repository,

  );


});