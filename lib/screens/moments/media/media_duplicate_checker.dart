import 'dart:io';

import 'package:crypto/crypto.dart';



class MediaDuplicateChecker {


  final Set<String> _hashes = {};





  Future<bool> exists(
      String path,
      ) async {


    final bytes =
    await File(path)
        .readAsBytes();



    final hash =
    sha256
        .convert(bytes)
        .toString();



    if(_hashes.contains(hash)){

      return true;

    }



    _hashes.add(hash);


    return false;


  }


}