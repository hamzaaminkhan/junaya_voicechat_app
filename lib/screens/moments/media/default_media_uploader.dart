import 'media_uploader.dart';



class DefaultMediaUploader implements MediaUploader {



  @override
  Future<String> upload({

    required String filePath,

    required String momentId,

    required Function(double progress) onProgress,

  }) async {



    onProgress(0.25);


    await Future.delayed(

      const Duration(

        milliseconds: 200,

      ),

    );


    onProgress(0.75);



    await Future.delayed(

      const Duration(

        milliseconds: 200,

      ),

    );


    onProgress(1.0);



    // temporary local return
    // replace with Firebase/API URL later

    return filePath;


  }








  @override
  Future<void> delete(

      String url,

      ) async {


    // remote delete later


  }








  @override
  Future<bool> exists(

      String url,

      ) async {


    // temporary implementation

    return false;


  }



}