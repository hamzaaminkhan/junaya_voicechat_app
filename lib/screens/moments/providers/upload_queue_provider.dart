import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../media/upload_queue.dart';

final uploadQueueProvider = Provider<UploadQueue>((ref) {
  return UploadQueue();
});