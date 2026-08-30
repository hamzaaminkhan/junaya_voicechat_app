import 'dart:convert';

import 'package:junaya_voicechat_app/screens/moments/data/moment_draft_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MomentDraftStorage {
  static const String _storageKey =
      'junaya_moment_draft';

  Future<void> save(
      MomentDraft draft,
      ) async {
    final preferences =
    await SharedPreferences.getInstance();

    final data = <String, dynamic>{
      'id': draft.id,
      'caption': draft.caption,
      'mediaPaths': draft.mediaPaths,
      'location': draft.location,
      'visibility': draft.visibility,
      'voicePath': draft.voicePath,
      'voiceDuration':
      draft.voiceDuration?.inMilliseconds,
      'createdAt':
      draft.createdAt.toIso8601String(),
      'updatedAt':
      draft.updatedAt.toIso8601String(),
    };

    await preferences.setString(
      _storageKey,
      jsonEncode(data),
    );
  }

  Future<MomentDraft?> load() async {
    final preferences =
    await SharedPreferences.getInstance();

    final raw =
    preferences.getString(_storageKey);

    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded =
      jsonDecode(raw);

      if (decoded is! Map) {
        return null;
      }

      final map =
      Map<String, dynamic>.from(
        decoded,
      );

      final media =
      map['mediaPaths'];

      final mediaPaths =
      media is List
          ? media
          .whereType<String>()
          .toList()
          : <String>[];

      final voiceDuration =
      map['voiceDuration'];

      return MomentDraft(
        id: map['id'] as String? ??
            _generateId(),
        caption:
        map['caption'] as String? ?? '',
        mediaPaths: mediaPaths,
        location:
        map['location'] as String?,
        visibility:
        map['visibility'] as String? ??
            'public',
        voicePath:
        map['voicePath'] as String?,
        voiceDuration:
        voiceDuration is int
            ? Duration(
          milliseconds:
          voiceDuration,
        )
            : null,
        createdAt:
        DateTime.tryParse(
          map['createdAt']
          as String? ??
              '',
        ) ??
            DateTime.now(),
        updatedAt:
        DateTime.tryParse(
          map['updatedAt']
          as String? ??
              '',
        ) ??
            DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final preferences =
    await SharedPreferences.getInstance();

    await preferences.remove(
      _storageKey,
    );
  }

  Future<bool> exists() async {
    final preferences =
    await SharedPreferences.getInstance();

    return preferences.containsKey(
      _storageKey,
    );
  }

  String _generateId() {
    return DateTime.now()
        .microsecondsSinceEpoch
        .toString();
  }
}