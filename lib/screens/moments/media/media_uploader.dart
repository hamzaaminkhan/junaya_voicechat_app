// =====================================================
// MEDIA UPLOADER CONTRACT
// =====================================================


abstract class MediaUploader {


  Future<String> upload({

    required String filePath,

    required String momentId,

    required Function(double progress) onProgress,

  });




  Future<void> delete(

      String url,

      );





  // =====================================================
  // CHECK REMOTE EXISTS
  // =====================================================


  Future<bool> exists(

      String url,

      );



}