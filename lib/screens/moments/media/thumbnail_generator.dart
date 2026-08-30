import 'package:video_thumbnail_gdx_plus/video_thumbnail_gdx_plus.dart';

class ThumbnailGenerator {
  Future<String?> generate(
      String path,
      ) async {
    return VideoThumbnail.thumbnailFile(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 400,
    );
  }
}