import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../media/upload_worker.dart';
import '../media/upload_queue.dart';
import '../media/media_uploader.dart';

import 'media_upload_service_provider.dart';
import 'media_uploader_provider.dart';
import 'upload_queue_provider.dart';

final uploadWorkerProvider = Provider<UploadWorker>((ref) {

  final queue = ref.watch(
    uploadQueueProvider,
  );

  final uploader = ref.watch(
    mediaUploaderProvider,
  );

  final uploadService = ref.watch(
    mediaUploadServiceProvider,
  );

  final worker = UploadWorker(
    queue: queue,
    uploader: uploader,
    uploadService: uploadService,
  );

  worker.start();

  ref.onDispose(() {
    worker.stop();
  });

  return worker;
});