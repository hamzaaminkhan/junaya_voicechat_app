import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/storage/media_storage.dart';



final mediaStorageProvider =

Provider<MediaStorage>((ref) {


  return MediaStorage();


});