import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/storage/media_storage.dart';

import 'media_compressor.dart';
import 'thumbnail_generator.dart';
import 'media_duplicate_checker.dart';
import 'upload_queue.dart';



class MediaPipeline {


  final MediaStorage storage;

  final MediaCompressor compressor;

  final ThumbnailGenerator thumbnail;

  final MediaDuplicateChecker duplicateChecker;

  final UploadQueue uploadQueue;





  MediaPipeline({

    required this.storage,

    required this.compressor,

    required this.thumbnail,

    required this.duplicateChecker,

    required this.uploadQueue,

  });








  Future<List<MomentMedia>> process({

    required String momentId,

    required List<String> files,

  }) async {



    final List<MomentMedia> result = [];





    for(int i = 0; i < files.length; i++){


      try {



        String path =
        files[i];






        // ==================================
        // DUPLICATE CHECK
        // ==================================


        final duplicate =

        await duplicateChecker.exists(
          path,
        );



        if(duplicate){

          continue;

        }







        // ==================================
        // COMPRESS
        // ==================================


        path =

        await compressor.compress(
          path,
        );







        // ==================================
        // SAVE MEDIA
        // ==================================


        final savedList =

        await storage.saveMedia(

          momentId:

          momentId,


          paths:

          [
            path,
          ],

        );



        if(savedList.isEmpty){

          continue;

        }



        var media =
            savedList.first;








        // ==================================
        // THUMBNAIL
        // ==================================


        final thumbnailPath =

        await thumbnail.generate(

          media.url,

        );





        media =

            media.copyWith(

              thumbnail:

              thumbnailPath,

            );








        // ==================================
        // UPLOAD QUEUE
        // ==================================


        uploadQueue.add(

          UploadTask(

            filePath:

            media.url,


            momentId:

            momentId,

          ),

        );








        result.add(
          media,
        );



      }



      catch(error){


        // production:
        // log error instead of silent failure

        continue;


      }


    }






    return result;


  }



}