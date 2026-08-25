import 'dart:convert';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'media_storage.dart';

class MomentStorage {


  static const String _storageKey =
      'junaya_moments_v4';



  final SharedPreferencesAsync _preferences =
  SharedPreferencesAsync();



  final MediaStorage mediaStorage;



  Future<void> _writeLock =
  Future.value();





  MomentStorage({

    required this.mediaStorage,

  });





  // ==================================================
  // CREATE
  // ==================================================


  Future<Moment> createMoment({

    required Moment moment,

    required List<String> mediaPaths,

  }) async {



    final List<MomentMedia> media =

    await mediaStorage.saveMedia(

      momentId: moment.id,

      paths: mediaPaths,

    );



    final updated =

    moment.copyWith(

      media:

      media.isEmpty

          ?

      moment.media

          :

      media,

    );



    final moments =
    await loadMoments();



    final updatedList = [

      updated,


      ...moments.where(

            (item)=>

        item.id != updated.id,

      ),

    ];



    await _write(

      updatedList,

    );



    return updated;

  }







  // ==================================================
  // READ
  // ==================================================


  Future<List<Moment>> loadMoments() async {


    final raw =

    await _preferences.getString(

      _storageKey,

    );



    if(raw == null || raw.isEmpty){

      return [];

    }



    try {


      final decoded =
      jsonDecode(raw);



      if(decoded is! List){

        return [];

      }



      final moments =

      decoded

          .whereType<Map>()

          .map(

              (item)=>

              Moment.fromJson(

                Map<String,dynamic>.from(

                  item,

                ),

              )

      )

          .toList();



      moments.sort(

            (a,b)=>

            b.createdAt.compareTo(

              a.createdAt,

            ),

      );



      return moments;


    }

    catch(_){

      return [];

    }


  }







  Future<Moment?> getMoment(

      String id,

      ) async {



    final moments =
    await loadMoments();



    for(final item in moments){


      if(item.id == id){

        return item;

      }

    }



    return null;

  }







  // ==================================================
  // UPDATE
  // ==================================================


  Future<void> updateMoment(

      Moment updated,

      ) async {



    final moments =
    await loadMoments();



    final index =

    moments.indexWhere(

          (item)=>

      item.id == updated.id,

    );



    if(index == -1){

      throw Exception(

        'Moment not found',

      );

    }



    moments[index] =
        updated;



    await _write(

      moments,

    );


  }







  // ==================================================
  // DELETE
  // ==================================================


  Future<void> deleteMoment(

      String id,

      ) async {



    final moments =
    await loadMoments();



    final target =
    await getMoment(id);



    if(target != null){


      await mediaStorage.deleteMedia(

        target.media,

      );


    }



    moments.removeWhere(

          (item)=>

      item.id == id,

    );



    await _write(

      moments,

    );


  }







  // ==================================================
  // LIKE
  // ==================================================


  Future<void> updateLike({

    required String id,

    required bool liked,

  }) async {



    final moment =
    await getMoment(id);



    if(moment == null){

      return;

    }



    final current =
        moment.stats.likes;



    final updated =

    moment.copyWith(

      isLiked: liked,


      stats:

      moment.stats.copyWith(

        likes:

        liked

            ?

        current + 1


            :

        current > 0

            ?

        current - 1

            :

        0,

      ),

    );



    await updateMoment(

      updated,

    );


  }







  // ==================================================
  // CLEAR
  // ==================================================


  Future<void> clear() async {



    await _preferences.remove(

      _storageKey,

    );



    await mediaStorage.clear();

  }







  // ==================================================
  // WRITE
  // ==================================================


  Future<void> _write(

      List<Moment> moments,

      ) async {



    final data =

    jsonEncode(

      moments

          .map(

              (item)=>

              item.toJson()

      )

          .toList(),

    );



    await _locked(

          () async {



        await _preferences.setString(

          _storageKey,

          data,

        );



      },

    );


  }







  Future<T> _locked<T>(

      Future<T> Function() action,

      ) {



    final result =

    _writeLock.then(

          (_) => action(),

    );



    _writeLock =

        result.then(

              (_) {},

        );



    return result;

  }


}