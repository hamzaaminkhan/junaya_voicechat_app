import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class MediaCompressor {

  Future<String> compress(
      String path,
      ) async {

    final file =
    File(path);

    final target =
        '${file.parent.path}/compressed_${file.uri.pathSegments.last}';

    final result =
    await FlutterImageCompress.compressAndGetFile(

      file.absolute.path,

      target,

      quality:
      80,

      minWidth:
      1080,

      minHeight:
      1080,

    );



    return result?.path ?? path;


  }



}