import 'dart:collection';



// =====================================================
// UPLOAD STATUS
// =====================================================


enum UploadStatus {

  pending,

  uploading,

  completed,

  failed,

}









// =====================================================
// UPLOAD TASK
// =====================================================


class UploadTask {


  final String id;


  final String filePath;


  final String momentId;


  final UploadStatus status;


  final int retryCount;


  final double progress;


  final bool processing;


  final DateTime createdAt;


  final DateTime updatedAt;





  const UploadTask({

    required this.id,

    required this.filePath,

    required this.momentId,

    this.status =
        UploadStatus.pending,

    this.retryCount =
    0,

    this.progress =
    0,

    this.processing =
    false,

    required this.createdAt,

    required this.updatedAt,

  });









  factory UploadTask.create({

    required String id,

    required String filePath,

    required String momentId,

  }) {


    final now =
    DateTime.now();



    return UploadTask(

      id: id,

      filePath: filePath,

      momentId: momentId,

      createdAt: now,

      updatedAt: now,

    );


  }









  UploadTask copyWith({

    UploadStatus? status,

    int? retryCount,

    double? progress,

    bool? processing,

  }) {


    return UploadTask(

      id: id,

      filePath: filePath,

      momentId: momentId,

      status:

      status ??
          this.status,


      retryCount:

      retryCount ??
          this.retryCount,


      progress:

      progress ??
          this.progress,


      processing:

      processing ??
          this.processing,


      createdAt:

      createdAt,


      updatedAt:

      DateTime.now(),

    );


  }









  Map<String,dynamic> toJson(){


    return {


      "id": id,


      "filePath": filePath,


      "momentId": momentId,


      "status": status.name,


      "retryCount": retryCount,


      "progress": progress,


      "processing": processing,


      "createdAt":
      createdAt.toIso8601String(),


      "updatedAt":
      updatedAt.toIso8601String(),


    };


  }









  factory UploadTask.fromJson(

      Map<String,dynamic> json,

      ){


    return UploadTask(

      id:

      json['id'] ?? '',


      filePath:

      json['filePath'] ?? '',


      momentId:

      json['momentId'] ?? '',


      status:

      UploadStatus.values.firstWhere(

            (item)=>

        item.name == json['status'],

        orElse:

            ()=> UploadStatus.pending,

      ),



      retryCount:

      json['retryCount'] ?? 0,


      progress:

      (json['progress'] ?? 0)

          .toDouble(),


      processing:

      json['processing'] ?? false,


      createdAt:

      DateTime.tryParse(

        json['createdAt'] ?? '',

      )

          ??

          DateTime.now(),



      updatedAt:

      DateTime.tryParse(

        json['updatedAt'] ?? '',

      )

          ??

          DateTime.now(),

    );


  }



}









// =====================================================
// UPLOAD QUEUE
// =====================================================


class UploadQueue {



  final List<UploadTask> _queue = [];









  // =====================================================
  // ADD
  // =====================================================


  Future<void> add(

      UploadTask task,

      ) async {


    final exists =

    _queue.any(

          (item)=>

      item.id == task.id,

    );



    if(exists){

      return;

    }



    _queue.add(task);


    await _save();


  }









  // =====================================================
  // GET NEXT TASK
  // =====================================================


  Future<UploadTask?> next() async {


    try {


      return _queue.firstWhere(

            (task)=>


        (

            task.status == UploadStatus.pending

                ||

                task.status == UploadStatus.failed

        )

            &&

            !task.processing,


      );


    }


    catch(_){


      return null;


    }


  }









  // =====================================================
  // START
  // =====================================================


  Future<void> start(

      String id,

      ) async {


    await update(

      id,

          (task)=>

          task.copyWith(

            status:

            UploadStatus.uploading,


            processing:

            true,

          ),

    );


  }









  // =====================================================
  // COMPLETE
  // =====================================================


  Future<void> complete(

      String id,

      ) async {


    await update(

      id,

          (task)=>

          task.copyWith(

            status:

            UploadStatus.completed,


            progress:

            1,


            processing:

            false,

          ),

    );


  }









  // =====================================================
  // FAIL
  // =====================================================


  Future<void> fail(

      String id,

      ) async {


    await update(

      id,

          (task)=>

          task.copyWith(

            status:

            UploadStatus.failed,


            processing:

            false,

          ),

    );


  }









  // =====================================================
  // PROGRESS
  // =====================================================


  Future<void> updateProgress({

    required String id,

    required double progress,

  }) async {


    await update(

      id,

          (task)=>

          task.copyWith(

            progress:

            progress.clamp(

              0,

              1,

            ),

          ),

    );


  }









  // =====================================================
  // RETRY
  // =====================================================


  Future<void> retry(

      String id,

      ) async {


    await update(

      id,

          (task)=>

          task.copyWith(

            status:

            UploadStatus.pending,


            retryCount:

            task.retryCount + 1,


            progress:

            0,


            processing:

            false,

          ),

    );


  }









  // =====================================================
  // UPDATE
  // =====================================================


  Future<void> update(

      String id,

      UploadTask Function(
          UploadTask task
          )

      action,

      ) async {


    final index =

    _queue.indexWhere(

          (task)=>

      task.id == id,

    );



    if(index == -1){

      return;

    }



    _queue[index] =

        action(

          _queue[index],

        );



    await _save();


  }









  // =====================================================
  // REMOVE
  // =====================================================


  Future<void> remove(

      String id,

      ) async {


    _queue.removeWhere(

          (task)=>

      task.id == id,

    );


    await _save();


  }









  // =====================================================
  // RECOVER STUCK UPLOADS
  // =====================================================


  Future<void> recover() async {


    for(int i = 0; i < _queue.length; i++){


      final task = _queue[i];



      if(task.status == UploadStatus.uploading){


        _queue[i] =

            task.copyWith(

              status:

              UploadStatus.pending,


              processing:

              false,

            );


      }


    }



    await _save();


  }









  // =====================================================
  // READ
  // =====================================================


  UnmodifiableListView<UploadTask> get tasks =>

      UnmodifiableListView(

        _queue,

      );









  List<UploadTask> get pending =>


      _queue.where(

            (task)=>

        task.status == UploadStatus.pending,

      )

          .toList();









  List<UploadTask> get failed =>


      _queue.where(

            (task)=>

        task.status == UploadStatus.failed,

      )

          .toList();









  // =====================================================
  // CLEAR
  // =====================================================


  Future<void> clear() async {


    _queue.clear();


    await _save();


  }









  // =====================================================
  // PERSISTENCE
  // =====================================================


  Future<void> _save() async {


    // TODO:
    // Hive / SQLite / SharedPreferences
    //
    // Save:
    // _queue.map((e)=>e.toJson())

  }



}