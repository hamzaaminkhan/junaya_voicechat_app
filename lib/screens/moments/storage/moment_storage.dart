import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';



class MomentStorage {


  static const String _storageKey =
      'junaya_moments_v6';


  static const String _backupKey =
      'junaya_moments_v6_backup';




  final SharedPreferencesAsync _preferences =
  SharedPreferencesAsync();




  Future<void> _writeLock =
  Future.value();









  // =====================================================
  // CREATE
  // =====================================================


  Future<Moment> createMoment(

      Moment moment,

      ) async {


    return _locked(() async {



      final moments =
      await _loadUnsafe();



      final updated = [

        moment,

        ...moments.where(

              (item)=>

          item.id != moment.id,

        ),

      ];



      await _writeUnsafe(
        updated,
      );



      return moment;


    });


  }









  // =====================================================
  // READ ALL
  // =====================================================


  Future<List<Moment>> loadMoments() async {

    return await _loadUnsafe();

  }









  Future<List<Moment>> _loadUnsafe() async {


    try {



      final raw =

      await _preferences.getString(
        _storageKey,
      );



      if(raw == null ||
          raw.isEmpty){

        return [];

      }





      final decoded =

      jsonDecode(raw);



      if(decoded is! List){

        return [];

      }





      return _decodeList(
        decoded,
      );



    }


    catch(_){



      return await _restoreBackup();


    }



  }









  List<Moment> _decodeList(

      List data,

      ){


    final moments =

    data

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









  // =====================================================
  // SINGLE
  // =====================================================


  Future<Moment?> getMoment(

      String id,

      ) async {


    final moments =

    await loadMoments();



    for(final moment in moments){


      if(moment.id == id){

        return moment;

      }


    }



    return null;


  }









  // =====================================================
  // UPDATE
  // =====================================================


  Future<void> updateMoment(

      Moment moment,

      ) async {



    await _locked(() async {



      final moments =

      await _loadUnsafe();



      final index =

      moments.indexWhere(

            (item)=>

        item.id == moment.id,

      );



      if(index == -1){


        throw Exception(

          "Moment not found",

        );


      }





      moments[index] = moment;



      await _writeUnsafe(

        moments,

      );



    });


  }









  // =====================================================
  // DELETE
  // =====================================================


  Future<void> deleteMoment(

      String id,

      ) async {



    await _locked(() async {



      final moments =

      await _loadUnsafe();



      final before =

          moments.length;



      moments.removeWhere(

            (item)=>

        item.id == id,

      );





      if(before != moments.length){


        await _writeUnsafe(

          moments,

        );


      }



    });


  }









  // =====================================================
  // PAGINATION
  // =====================================================


  Future<List<Moment>> loadPage({

    required int limit,

    String? cursor,

  }) async {



    final moments =

    await loadMoments();



    var start = 0;



    if(cursor != null){



      final index =

      moments.indexWhere(

            (item)=>

        item.id == cursor,

      );



      if(index != -1){

        start = index + 1;

      }



    }




    return moments

        .skip(start)

        .take(limit)

        .toList();


  }









  // =====================================================
  // SEARCH
  // =====================================================


  Future<List<Moment>> search(

      String query,

      ) async {



    final moments =

    await loadMoments();



    final value =

    query.trim().toLowerCase();



    if(value.isEmpty){

      return moments;

    }





    return moments.where(

          (moment){



        final caption =

        moment.caption

            .toLowerCase();



        final username =

        moment.author.username

            .toLowerCase();



        final hashtags =

        moment.hashtags

            .join(' ')

            .toLowerCase();





        return caption.contains(value)

            ||

            username.contains(value)

            ||

            hashtags.contains(value);



      },

    ).toList();



  }









  // =====================================================
  // USER MOMENTS
  // =====================================================


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









  // =====================================================
  // CLEAR
  // =====================================================


  Future<void> clear() async {


    await _preferences.remove(

      _storageKey,

    );



    await _preferences.remove(

      _backupKey,

    );


  }









  // =====================================================
  // WRITE
  // =====================================================


  Future<void> _writeUnsafe(

      List<Moment> moments,

      ) async {



    final encoded =

    jsonEncode(

      moments

          .map(

            (item)=>

            item.toJson(),

      )

          .toList(),

    );





    final old =

    await _preferences.getString(

      _storageKey,

    );



    if(old != null){


      await _preferences.setString(

        _backupKey,

        old,

      );


    }





    await _preferences.setString(

      _storageKey,

      encoded,

    );





    // remove stale backup

    await _preferences.remove(

      _backupKey,

    );


  }









  // =====================================================
  // RESTORE
  // =====================================================


  Future<List<Moment>> _restoreBackup() async {



    try {



      final backup =

      await _preferences.getString(

        _backupKey,

      );



      if(backup == null){

        return [];

      }





      final decoded =

      jsonDecode(

        backup,

      );





      if(decoded is! List){

        return [];

      }





      return _decodeList(

        decoded,

      );



    }

    catch(_){


      return [];


    }



  }









  // =====================================================
  // WRITE LOCK
  // =====================================================


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