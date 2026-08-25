class UploadTask {


  final String filePath;


  final String momentId;



  const UploadTask({

    required this.filePath,

    required this.momentId,

  });


}





class UploadQueue {


  final List<UploadTask> _queue=[];



  void add(
      UploadTask task,
      ){

    _queue.add(task);

  }



  List<UploadTask> get pending =>
      List.unmodifiable(
        _queue,
      );


}