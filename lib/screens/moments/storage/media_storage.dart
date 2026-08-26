import 'dart:io';

import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



class MediaStorage {


  static const String folderName =
      'junaya_moments';



  static const int maxFileSize =
      25 * 1024 * 1024;






  // ==================================================
  // DIRECTORY
  // ==================================================


  Future<Directory> _directory() async {


    final root =
    await getApplicationDocumentsDirectory();



    final folder =
    Directory(

      p.join(

        root.path,

        folderName,

      ),

    );



    if(!await folder.exists()){

      await folder.create(
        recursive: true,
      );

    }



    return folder;

  }









  // ==================================================
  // SAVE MULTIPLE MEDIA
  // ==================================================


  Future<List<MomentMedia>> saveMedia({

    required String momentId,

    required List<String> paths,

  }) async {


    final List<MomentMedia> result = [];



    for(int i = 0; i < paths.length; i++){


      try{


        final media =
        await saveFile(

          momentId:
          momentId,


          path:
          paths[i],


          order:
          i,


        );



        result.add(media);


      }

      catch(_){

        continue;

      }


    }



    return result;


  }









  // ==================================================
  // SAVE SINGLE FILE
  // ==================================================
  Future<MomentMedia> saveFile({

    required String momentId,

    required String path,

    required int order,

  }) async {


    final source = File(path);



    if(!await source.exists()){

      throw Exception(
        "Media file not found",
      );

    }




    final size = await source.length();



    if(size > maxFileSize){

      throw Exception(
        "Media exceeds size limit",
      );

    }





    final extension = _extension(
      source.path,
    );



    if(extension == null ||
        !_supported(extension)){


      throw Exception(
        "Unsupported media",
      );

    }






    final detectedMime =

    lookupMimeType(
      source.path,
    );





    final folder =

    await _directory();






    final id = _generateId();





    final filename =

        '${momentId}_${id}_$order$extension';





    final destination =

    p.join(

      folder.path,

      filename,

    );






    final copied =

    await source.copy(

      destination,

    );






    return MomentMedia(

      id:id,


      url:copied.path,


      type:_mediaType(
        extension,
      ),



      order:order,



      size:

      await copied.length(),



      mimeType:

      detectedMime ??

          mimeType(
            extension,
          ),


    );


  }



  // ==================================================
  // DELETE MULTIPLE
  // ==================================================


  Future<void> deleteMedia(

      List<MomentMedia> media,

      ) async {


    for(final item in media){


      await deleteSingle(
        item.url,
      );


      if(item.thumbnail != null){

        await deleteSingle(
          item.thumbnail!,
        );

      }


    }


  }









  // ==================================================
  // DELETE SINGLE
  // ==================================================


  Future<void> deleteSingle(

      String path,

      ) async {


    try{


      final file =
      File(path);



      if(await file.exists()){

        await file.delete();

      }


    }

    catch(_){}



  }









  // ==================================================
  // MEDIA TYPE
  // ==================================================


  MomentMediaType _mediaType(

      String extension,

      ){


    switch(extension){


      case '.mp4':

      case '.mov':

      case '.avi':

      case '.mkv':

      case '.webm':

      case '.3gp':

        return MomentMediaType.video;



      default:

        return MomentMediaType.image;


    }


  }









  // ==================================================
  // SUPPORTED FORMATS
  // ==================================================


  bool _supported(

      String extension,

      ){


    const formats = {


      // images

      '.jpg',

      '.jpeg',

      '.png',

      '.webp',

      '.gif',

      '.heic',

      '.heif',

      '.bmp',

      '.tiff',

      '.tif',

      '.avif',



      // videos

      '.mp4',

      '.mov',

      '.avi',

      '.mkv',

      '.webm',

      '.3gp',


    };



    return formats.contains(
      extension,
    );


  }









  // ==================================================
  // EXTENSION DETECTION
  // ==================================================


  String? _extension(

      String path,

      ){



    final existing =

    p.extension(path)

        .trim()

        .toLowerCase();





    if(existing.isNotEmpty){

      return existing;

    }





    final mime =

    lookupMimeType(path);





    switch(mime){



      case 'image/jpeg':
        return '.jpg';



      case 'image/png':
        return '.png';



      case 'image/webp':
        return '.webp';



      case 'image/gif':
        return '.gif';



      case 'image/heic':
        return '.heic';



      case 'image/heif':
        return '.heif';



      case 'image/avif':
        return '.avif';





      case 'video/mp4':
        return '.mp4';



      case 'video/quicktime':
        return '.mov';



      case 'video/x-msvideo':
        return '.avi';



      case 'video/x-matroska':
        return '.mkv';



      case 'video/webm':
        return '.webm';



      case 'video/3gpp':
        return '.3gp';



      default:

        return null;


    }


  }









  // ==================================================
  // MIME
  // ==================================================


  String mimeType(

      String extension,

      ){


    switch(extension){



      case '.jpg':

      case '.jpeg':

        return 'image/jpeg';



      case '.png':

        return 'image/png';



      case '.webp':

        return 'image/webp';



      case '.gif':

        return 'image/gif';



      case '.heic':

        return 'image/heic';



      case '.heif':

        return 'image/heif';



      case '.avif':

        return 'image/avif';



      case '.mp4':

        return 'video/mp4';



      case '.mov':

        return 'video/quicktime';



      case '.avi':

        return 'video/x-msvideo';



      case '.mkv':

        return 'video/x-matroska';



      case '.webm':

        return 'video/webm';



      case '.3gp':

        return 'video/3gpp';



      default:

        return 'application/octet-stream';


    }


  }









  // ==================================================
  // CLEAR STORAGE
  // ==================================================


  Future<void> clear() async {


    try{


      final folder =
      await _directory();



      if(await folder.exists()){


        await folder.delete(
          recursive: true,
        );



        await folder.create(
          recursive: true,
        );


      }


    }

    catch(_){}



  }









  // ==================================================
  // ID
  // ==================================================


  String _generateId(){

    return DateTime.now()
        .microsecondsSinceEpoch
        .toString();


  }


}