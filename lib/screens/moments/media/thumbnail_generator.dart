import 'package:video_thumbnail/video_thumbnail.dart';



class ThumbnailGenerator {


  Future<String?> generate(
      String path,
      ) async {


    return VideoThumbnail.thumbnailFile(

      video:
      path,


      imageFormat:
      ImageFormat.JPEG,


      maxHeight:
      400,


    );


  }


}