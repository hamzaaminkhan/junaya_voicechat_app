import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../media/upload_worker.dart';
import '../media/upload_queue.dart';
import '../media/media_uploader.dart';



final uploadQueueProvider =

Provider<UploadQueue>((ref){

  return UploadQueue();

});







final mediaUploaderProvider =

Provider<MediaUploader>((ref){

  throw UnimplementedError(
    "Provide uploader implementation",
  );

});







final uploadWorkerProvider =

Provider<UploadWorker>((ref){


  final worker = UploadWorker(

    queue:

    ref.watch(

      uploadQueueProvider,

    ),


    uploader:

    ref.watch(

      mediaUploaderProvider,

    ),

  );



  ref.onDispose((){


    worker.stop();


  });



  return worker;


});