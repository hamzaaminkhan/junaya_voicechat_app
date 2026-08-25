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





  const UploadTask({

    required this.id,

    required this.filePath,

    required this.momentId,

    this.status =
        UploadStatus.pending,

    this.retryCount =
    0,

  });







  UploadTask copyWith({

    UploadStatus? status,

    int? retryCount,

  }) {


    return UploadTask(

      id:
      id,


      filePath:
      filePath,


      momentId:
      momentId,


      status:

      status ??
          this.status,


      retryCount:

      retryCount ??
          this.retryCount,


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



    _queue.add(

      task,

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
  // UPDATE STATUS
  // =====================================================


  Future<void> updateStatus({

    required String id,

    required UploadStatus status,

  }) async {



    final index =

    _queue.indexWhere(

          (task)=>

      task.id == id,

    );



    if(index == -1){

      return;

    }





    _queue[index] =

        _queue[index].copyWith(

          status:

          status,

        );



    await _save();


  }









  // =====================================================
  // RETRY
  // =====================================================


  Future<void> retry(

      String id,

      ) async {



    final index =

    _queue.indexWhere(

          (task)=>

      task.id == id,

    );



    if(index == -1){

      return;

    }





    final task =
    _queue[index];



    _queue[index] =

        task.copyWith(

          status:

          UploadStatus.pending,


          retryCount:

          task.retryCount + 1,


        );



    await _save();


  }









  // =====================================================
  // READ
  // =====================================================


  UnmodifiableListView<UploadTask> get pending {


    return UnmodifiableListView(

      _queue,

    );


  }









  List<UploadTask> get failed {


    return _queue

        .where(

          (task)=>

      task.status ==
          UploadStatus.failed,

    )

        .toList();


  }









  // =====================================================
  // CLEAR
  // =====================================================


  Future<void> clear() async {


    _queue.clear();


    await _save();


  }









  // =====================================================
  // PERSISTENCE PLACEHOLDER
  // =====================================================


  Future<void> _save() async {


    // Next step:
    // Store queue in Hive/SQLite/SharedPreferences


  }



}