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


    for(int index = 0; index < files.length; index++){

      try{

        final original = files[index];


        if(original.trim().isEmpty){
          continue;
        }


        final compressed =
        await compressor.compress(
          original,
        );


        final duplicate =
        await duplicateChecker.exists(
          compressed,
        );


        if(duplicate){
          continue;
        }


        final saved =
        await storage.saveMedia(
          momentId: momentId,
          paths: [
            compressed,
          ],
        );


        if(saved.isEmpty){
          continue;
        }


        var media = saved.first;


        String? thumbnailPath;


        try{

          thumbnailPath =
          await thumbnail.generate(
            media.localPath,
          );

        }
        catch(_){

          thumbnailPath = null;

        }


        media =
            media.copyWith(
              thumbnail: thumbnailPath,
              processing: false,
              uploaded: false,
              uploadProgress: 0,
            );



        await uploadQueue.add(

          UploadTask.create(

            id: media.id,

            filePath: media.localPath,

            momentId: momentId,

          ),

        );


        result.add(
          media,
        );


      }
      catch(_){

        continue;

      }

    }


    return result;

  }

}