import 'upload_queue.dart';
import 'media_uploader.dart';
import '../services/media_upload_service.dart';


class UploadWorker {

  final UploadQueue queue;
  final MediaUploader uploader;
  final MediaUploadService uploadService;


  bool _running = false;
  Future<void>? _workerTask;


  UploadWorker({
    required this.queue,
    required this.uploader,
    required this.uploadService,
  });


  Future<void> start() async {

    if(_running){

      return _workerTask;

    }


    _running = true;

    _workerTask = _run();

    return _workerTask;

  }


  Future<void> _run() async {

    await queue.recover();


    while(_running){

      final task =
      await queue.next();


      if(task == null){

        await Future.delayed(
          const Duration(
            seconds: 2,
          ),
        );

        continue;

      }


      await _process(
        task,
      );

    }

  }


  Future<void> _process(
      UploadTask task,
      ) async {

    try{

      await queue.start(
        task.id,
      );


      final remoteUrl =
      await uploader.upload(

        filePath:
        task.filePath,

        momentId:
        task.momentId,

        onProgress:
            (progress){

          queue.updateProgress(

            id:
            task.id,

            progress:
            progress,

          );

        },

      );


      await uploadService.uploadMediaByTask(
        task: task,
        remoteUrl: remoteUrl,
      );


      await queue.complete(
        task.id,
      );


    }
    catch(_){

      await queue.fail(
        task.id,
      );

    }

  }


  Future<void> stop() async {

    _running = false;

    await _workerTask;

    _workerTask = null;

  }


  bool get isRunning =>
      _running;

}