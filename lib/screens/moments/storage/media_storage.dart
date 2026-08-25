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





  Future<Directory> _directory() async {


    final Directory root =
    await getApplicationDocumentsDirectory();



    final Directory folder =
    Directory(
      p.join(
        root.path,
        folderName,
      ),
    );



    if(!await folder.exists()){

      await folder.create(
        recursive:true,
      );

    }



    return folder;

  }







  Future<List<MomentMedia>> saveMedia({



    required String momentId,

    required List<String> paths,

  }) async {





    final Directory folder =
    await _directory();



    final List<MomentMedia> result=[];



    for(
    int index=0;
    index<paths.length;
    index++
    ){


      try {


        final File source =
        File(
          paths[index],
        );



        if(!await source.exists()){

          continue;

        }



        final int size =
        await source.length();



        if(size > maxFileSize){

          continue;

        }



        final String? extension =
        _extension(
          source.path,
        );


        if(extension == null){

          continue;

        }

        if(extension.isEmpty){

          continue;

        }



        if(!_supported(extension)){

          continue;

        }



        final String filename =

            '${momentId}_${_generateId()}_$index$extension';



        final String destination =

        p.join(
          folder.path,
          filename,
        );



        final File copied =
        await source.copy(
          destination,
        );



        result.add(

          MomentMedia(

            id:
            _generateId(),


            url:
            copied.path,


            type:
            _mediaType(extension),


            order:
            index,


            size:
            size,


            mimeType:
            mimeType(extension),

          ),

        );



      }

      catch(_){

        continue;

      }


    }



    return result;

  }









  Future<void> deleteMedia(

      List<MomentMedia> media,

      ) async {



    for(final item in media){


      try{


        final File file =
        File(
          item.url,
        );



        if(await file.exists()){

          await file.delete();

        }


      }

      catch(_){}



    }


  }









  Future<void> deleteSingle(
      String path,
      ) async {


    try{


      final File file =
      File(path);



      if(await file.exists()){

        await file.delete();

      }


    }

    catch(_){}


  }









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







  bool _supported(
      String extension,
      ){


    const supported = {


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


    return supported.contains(
      extension,
    );


  }

  bool _isAllowedMime(
      String? mime,
      ){

    if(mime == null){

      return false;

    }


    const allowed = {


      // Images

      'image/jpeg',
      'image/png',
      'image/webp',
      'image/gif',
      'image/heic',
      'image/heif',
      'image/avif',


      // Videos

      'video/mp4',
      'video/quicktime',
      'video/x-msvideo',
      'video/x-matroska',
      'video/webm',

    };


    return allowed.contains(
      mime,
    );

  }








  String? _extension(String path) {


    final existing =
    p.extension(path)
        .trim()
        .toLowerCase();



    // File already has extension

    if(existing.isNotEmpty){

      return existing;

    }



    // Detect from content

    final mime =
    lookupMimeType(path);



    if(mime == null){

      return null;

    }



    switch(mime){


    // Images

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



    // Videos

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


      default:

        return null;


    }


  }







  String mimeType(
      String extension,
      ){


    switch(extension){


      case '.png':
        return 'image/png';


      case '.webp':
        return 'image/webp';


      case '.gif':
        return 'image/gif';


      case '.heic':
      case '.heif':
        return 'image/heic';


      case '.avif':
        return 'image/avif';


      case '.bmp':
        return 'image/bmp';


      case '.tiff':
      case '.tif':
        return 'image/tiff';


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









  String _generateId(){

    return DateTime.now()
        .microsecondsSinceEpoch
        .toString();

  }

// ==================================================
// CLEAR ALL MEDIA
// ==================================================

  Future<void> clear() async {

    try {

      final Directory directory =
      await _directory();


      if(await directory.exists()) {

        await directory.delete(
          recursive: true,
        );


        await directory.create(
          recursive: true,
        );

      }


    } catch (_) {

      // Ignore cleanup errors

    }

  }

}