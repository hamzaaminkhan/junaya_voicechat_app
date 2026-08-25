import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';

import '../storage/media_storage.dart';

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





    for(int index = 0;
    index < files.length;
    index++){



      try {



        final original = files[index];





        // ==========================
        // VALIDATE
        // ==========================


        if(original.isEmpty){

          continue;

        }







        // ==========================
        // DUPLICATE CHECK
        // ==========================


        final exists =

        await duplicateChecker.exists(

          original,

        );



        if(exists){

          continue;

        }







        // ==========================
        // COMPRESS
        // ==========================


        final processedPath =

        await compressor.compress(

          original,

        );








        // ==========================
        // SAVE LOCAL FILE
        // ==========================


        final saved =

        await storage.saveMedia(

          momentId:

          momentId,


          paths:

          [

            processedPath

          ],


        );





        if(saved.isEmpty){

          continue;

        }





        final media =

            saved.first;








        // ==========================
        // THUMBNAIL
        // ==========================


        final thumb =

        await thumbnail.generate(

          media.url,

        );








        final updated =

        media.copyWith(

          thumbnail:

          thumb,

        );







        // ==========================
        // UPLOAD QUEUE
        // ==========================


        await uploadQueue.add(


          UploadTask(

            id:

            updated.id,


            filePath:

            updated.url,


            momentId:

            momentId,


          ),


        );








        result.add(

          updated,

        );




      }


      catch(error){


        // failed media should not
        // break whole moment


        continue;


      }


    }





    return result;


  }


}