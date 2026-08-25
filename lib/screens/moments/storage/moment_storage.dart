import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



class MomentStorage {


  static const String _storageKey =
      'junaya_moments_v5';



  final SharedPreferencesAsync _preferences =
  SharedPreferencesAsync();



  Future<void> _writeLock =
  Future.value();






  // ==================================================
  // CREATE
  // ==================================================


  Future<Moment> createMoment(

      Moment moment,

      ) async {


    final moments =
    await loadMoments();



    final updatedList = [


      moment,


      ...moments.where(

            (item) =>

        item.id != moment.id,

      ),


    ];



    await _write(
      updatedList,
    );



    return moment;


  }









  // ==================================================
  // READ ALL
  // ==================================================


  Future<List<Moment>> loadMoments() async {



    final raw =

    await _preferences.getString(
      _storageKey,
    );



    if(raw == null || raw.isEmpty){

      return [];

    }





    try{


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









  // ==================================================
  // READ SINGLE
  // ==================================================


  Future<Moment?> getMoment(

      String id,

      ) async {



    final moments =
    await loadMoments();



    try{


      return moments.firstWhere(

            (item)=>

        item.id == id,

      );


    }

    catch(_){


      return null;


    }



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



    moments.removeWhere(

          (item)=>

      item.id == id,

    );



    await _write(

      moments,

    );


  }









  // ==================================================
  // LIKE UPDATE
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





    final likes =
        moment.stats.likes;



    final updated =

    moment.copyWith(

      isLiked:
      liked,


      stats:

      moment.stats.copyWith(

        likes:

        liked

            ?

        likes + 1


            :

        likes > 0

            ?

        likes - 1

            :

        0,

      ),

    );





    await updateMoment(

      updated,

    );


  }









  // ==================================================
  // SEARCH SUPPORT
  // ==================================================


  Future<List<Moment>> search(

      String query,

      ) async {



    final moments =
    await loadMoments();



    final value =
    query.toLowerCase();



    return moments.where(

          (moment){


        return moment.caption

            .toLowerCase()

            .contains(value);


      },

    ).toList();


  }









  // ==================================================
  // USER MOMENTS
  // ==================================================


  Future<List<Moment>> getUserMoments(

      String userId,

      ) async {



    final moments =
    await loadMoments();



    return moments.where(

          (moment)=>

      moment.author.id == userId,

    ).toList();


  }









  // ==================================================
  // CLEAR DATABASE
  // ==================================================


  Future<void> clear() async {



    await _preferences.remove(

      _storageKey,

    );


  }









  // ==================================================
  // WRITE
  // ==================================================


  Future<void> _write(

      List<Moment> moments,

      ) async {



    final json =

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

          json,

        );



      },

    );


  }









  // ==================================================
  // WRITE LOCK
  // ==================================================


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