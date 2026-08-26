import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../media/media_uploader.dart';
import '../media/default_media_uploader.dart';



final mediaUploaderProvider =

Provider<MediaUploader>((ref){


  return DefaultMediaUploader();


});