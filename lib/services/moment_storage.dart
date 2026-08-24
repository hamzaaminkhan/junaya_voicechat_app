import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



class MomentStorage {


  static const String _storageKey =
      'junaya_moments_v2';



  final SharedPreferencesAsync _preferences =
  SharedPreferencesAsync();






  // CREATE MOMENT

  Future<Moment> createMoment({

    required Moment moment,

    required List<String> sourceImagePaths,

  }) async {


    final List<String> savedImages =
    await _copyImagesToAppFolder(
      momentId: moment.id,
      sourcePaths: sourceImagePaths,
    );



    final List<MomentMedia> media =
    savedImages
        .asMap()
        .entries
        .map(
          (entry) {

        return MomentMedia.image(
          url: entry.value,
          order: entry.key,
        );

      },
    )
        .toList();



    final Moment updated =
    moment.copyWith(
      media: media.isEmpty
          ? moment.media
          : media,
    );



    final List<Moment> moments =
    await loadMoments();



    await _writeMoments(
      [
        updated,
        ...moments.where(
              (item)=>item.id != updated.id,
        ),
      ],
    );


    return updated;

  }









  // LOAD ALL


  Future<List<Moment>> loadMoments() async {


    final String? raw =
    await _preferences.getString(
      _storageKey,
    );



    if(raw == null || raw.isEmpty){

      return [];

    }



    try{


      final dynamic decoded =
      jsonDecode(raw);



      if(decoded is! List){

        return [];

      }



      final List<Moment> moments =
      decoded
          .whereType<Map>()
          .map(
            (item)=>
            Moment.fromJson(
              Map<String,dynamic>.from(item),
            ),
      )
          .toList();



      moments.sort(
            (a,b)=>
            b.createdAt
                .compareTo(
              a.createdAt,
            ),
      );



      return moments;



    }catch(_){

      return [];

    }

  }









  // GET SINGLE MOMENT


  Future<Moment?> getMoment(
      String id,
      ) async {


    final moments =
    await loadMoments();



    try{

      return moments.firstWhere(
            (moment)=>
        moment.id == id,
      );


    }catch(_){

      return null;

    }

  }









  // UPDATE


  Future<void> updateMoment(
      Moment updated,
      ) async {


    final List<Moment> moments =
    await loadMoments();



    final index =
    moments.indexWhere(
          (item)=>
      item.id ==
          updated.id,
    );



    if(index == -1){

      throw Exception(
          "Moment does not exist"
      );

    }



    moments[index] =
        updated;



    await _writeMoments(
      moments,
    );


  }









  // DELETE


  Future<void> deleteMoment(
      String id,
      ) async {


    final moments =
    await loadMoments();



    final Moment? target =
    await getMoment(id);



    if(target != null){

      for(final media in target.media){

        try{

          final File file =
          File(media.url);



          if(await file.exists()){

            await file.delete();

          }

        }catch(_){}

      }

    }



    moments.removeWhere(
          (moment)=>
      moment.id == id,
    );



    await _writeMoments(
      moments,
    );


  }









  // LIKE UPDATE


  Future<void> updateLike(
      String id,
      bool liked,
      ) async {


    final moment =
    await getMoment(id);



    if(moment == null){

      return;

    }



    final updated =
    moment.copyWith(

      isLiked:
      liked,


        likesCount:
        liked
            ? moment.likesCount + 1
            : (moment.likesCount > 0
            ? moment.likesCount - 1
            : 0),


    );
    await updateMoment(
      updated);
  }

  // CLEAR DATABASE


  Future<void> clear() async {


    await _preferences.remove(
      _storageKey,
    );


  }


  // IMAGE STORAGE


  Future<List<String>>
  _copyImagesToAppFolder({

    required String momentId,

    required List<String> sourcePaths,

  }) async {



    if(sourcePaths.isEmpty){

      return [];

    }



    final Directory root =
    await getApplicationDocumentsDirectory();



    final Directory folder =
    Directory(
      p.join(
        root.path,
        'junaya_moments',
      ),
    );



    if(!await folder.exists()){

      await folder.create(
        recursive:true,
      );

    }



    final List<String> results = [];



    for(int i=0;i<sourcePaths.length;i++){


      try{


        final File source =
        File(
          sourcePaths[i],
        );



        if(!await source.exists()){

          continue;

        }



        String extension =
        p.extension(
          source.path,
        );



        if(extension.isEmpty){

          extension='.jpg';

        }



        final String destination =
        p.join(
          folder.path,
          '${momentId}_$i$extension',
        );



        final File copied =
        await source.copy(
          destination,
        );



        results.add(
          copied.path,
        );



      }catch(_){}


    }



    return results;

  }


  // WRITE


  Future<void> _writeMoments(
      List<Moment> moments,
      ) async {


    final String json =
    jsonEncode(
      moments
          .map(
            (moment)=>
            moment.toJson(),
      )
          .toList(),
    );



    await _preferences.setString(
      _storageKey,
      json,
    );


  }


}