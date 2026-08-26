import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_repository.dart';

import '../media/media_uploader.dart';



class MediaUploadService {


  final MediaUploader uploader;


  final MomentRepository repository;




  MediaUploadService({

    required this.uploader,

    required this.repository,

  });









  // =====================================================
  // UPLOAD SINGLE MEDIA
  // =====================================================


  Future<void> uploadMedia({

    required String momentId,

    required MomentMedia media,

  }) async {



    final remoteUrl =

    await uploader.upload(

      filePath:

      media.url,


      momentId:

      momentId,


      onProgress:

          (progress){


        // TODO:
        // connect upload progress

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

      url:

      remoteUrl,


      uploaded:

      true,


    );









    final updatedMediaList =

    moment.media.map(

          (item){


        if(item.id == media.id){

          return updatedMedia;

        }


        return item;


      },

    )

        .toList();









    final updatedMoment =

    moment.copyWith(

      media:

      updatedMediaList,

      updatedAt:

      DateTime.now(),

    );








    await repository.updateMoment(

      updatedMoment,

    );



  }









  // =====================================================
  // UPLOAD ALL PENDING MEDIA
  // =====================================================


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



}