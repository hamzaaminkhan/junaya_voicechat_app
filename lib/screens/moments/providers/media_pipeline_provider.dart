import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/media/media_pipeline.dart';
import 'package:junaya_voicechat_app/screens/moments/media/media_compressor.dart';
import 'package:junaya_voicechat_app/screens/moments/media/thumbnail_generator.dart';
import 'package:junaya_voicechat_app/screens/moments/media/media_duplicate_checker.dart';
import 'package:junaya_voicechat_app/screens/moments/media/upload_queue.dart';

import 'package:junaya_voicechat_app/screens/moments/providers/media_storage_provider.dart';




final mediaPipelineProvider =

Provider<MediaPipeline>((ref) {


  return MediaPipeline(


    storage:

    ref.read(
      mediaStorageProvider,
    ),



    compressor:

    MediaCompressor(),



    thumbnail:

    ThumbnailGenerator(),



    duplicateChecker:

    MediaDuplicateChecker(),



    uploadQueue:

    UploadQueue(),



  );


});