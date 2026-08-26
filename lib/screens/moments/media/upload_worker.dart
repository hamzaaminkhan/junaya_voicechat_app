import 'upload_queue.dart';
import 'media_uploader.dart';



class UploadWorker {


  final UploadQueue queue;


  final MediaUploader uploader;





  bool _running = false;


  Future<void>? _workerTask;









  UploadWorker({

    required this.queue,

    required this.uploader,

  });









  // =====================================================
  // START WORKER
  // =====================================================


  Future<void> start() async {


    if(_running){

      return _workerTask;

    }



    _running = true;



    _workerTask = _run();



    return _workerTask;


  }









  Future<void> _run() async {


    // recover interrupted uploads

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









  // =====================================================
  // PROCESS TASK
  // =====================================================


  Future<void> _process(

      UploadTask task,

      ) async {


    try {



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

            (progress) async {



          await queue.updateProgress(

            id:

            task.id,


            progress:

            progress,


          );


        },


      );







      await _complete(

        task,

        remoteUrl,

      );



    }



    catch(error){



      await queue.fail(

        task.id,

      );


    }


  }









  // =====================================================
  // COMPLETE
  // =====================================================


  Future<void> _complete(

      UploadTask task,

      String remoteUrl,

      ) async {



    /*

    Future:

    Update MomentStorage

    Find MomentMedia by id:

      uploaded = true

      remoteUrl = remoteUrl


    */





    await queue.complete(

      task.id,

    );



  }









  // =====================================================
  // STOP
  // =====================================================


  Future<void> stop() async {


    _running = false;



    await _workerTask;



    _workerTask = null;


  }





  bool get isRunning => _running;



}