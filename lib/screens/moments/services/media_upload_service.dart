import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_repository.dart';

import '../media/media_uploader.dart';
import '../media/upload_queue.dart';

class MediaUploadService {

  final MediaUploader uploader;
  final MomentRepository repository;


  MediaUploadService({
    required this.uploader,
    required this.repository,
  });


  Future<void> uploadMedia({
    required String momentId,
    required MomentMedia media,
  }) async {


    final remoteUrl =
    await uploader.upload(

      filePath:
      media.localPath,

      momentId:
      momentId,

      onProgress:
          (progress){

        // progress provider later

      },

    );



    final moment =
    await repository.getMoment(
      momentId,
    );


    if(moment == null){

      throw Exception(
        "Moment not found",
      );

    }



    final updatedMedia =
    media.copyWith(

      remoteUrl:
      remoteUrl,

      uploaded:
      true,

      uploadProgress:
      1,

    );



    final updatedList =
    moment.media.map(

          (item){

        if(item.id == media.id){

          return updatedMedia;

        }

        return item;

      },

    ).toList();



    final updatedMoment =
    moment.copyWith(

      media:
      updatedList,

      updatedAt:
      DateTime.now(),

    );



    await repository.updateMoment(
      updatedMoment,
    );

  }



  Future<void> uploadMomentMedia(
      Moment moment,
      ) async {


    final pending =
    moment.media.where(

          (item)=>

      !item.uploaded,

    ).toList();



    for(final media in pending){


      await uploadMedia(

        momentId:
        moment.id,

        media:
        media,

      );


    }

  }

  Future<void> uploadMediaByTask({
    required UploadTask task,
    required String remoteUrl,
  }) async {

    final moment =
    await repository.getMoment(
      task.momentId,
    );


    if(moment == null){
      throw Exception(
        "Moment not found",
      );
    }


    final updatedMedia =
    moment.media.map(

          (media){

        if(media.id == task.id){

          return media.copyWith(

            remoteUrl:
            remoteUrl,

            uploaded:
            true,

            uploadProgress:
            1,

          );

        }

        return media;

      },

    ).toList();


    await repository.updateMoment(

      moment.copyWith(
        media: updatedMedia,
        updatedAt: DateTime.now(),
      ),

    );

  }


}