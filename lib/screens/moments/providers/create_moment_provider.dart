import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/data/moment_repository.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';


final createMomentProvider =
NotifierProvider<CreateMomentNotifier, CreateMomentState>(
  CreateMomentNotifier.new,
);

class CreateMomentState {
  final String caption;
  final List<String> mediaPaths;
  final String? location;
  final bool isPublic;
  final String? voicePath;
  final bool isLoading;

  const CreateMomentState({
    this.caption = "",
    this.mediaPaths = const [],
    this.location,
    this.isPublic = true,
    this.voicePath,
    this.isLoading = false,
  });

  CreateMomentState copyWith({
    String? caption,
    List<String>? mediaPaths,
    String? location,
    bool? isPublic,
    String? voicePath,
    bool? isLoading,
  }) {
    return CreateMomentState(
      caption: caption ?? this.caption,
      mediaPaths: mediaPaths ?? this.mediaPaths,
      location: location ?? this.location,
      isPublic: isPublic ?? this.isPublic,
      voicePath: voicePath ?? this.voicePath,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CreateMomentNotifier
    extends Notifier<CreateMomentState> {

  late final MomentRepository repository;

  @override
  CreateMomentState build() {
    repository = ref.read(momentRepositoryProvider);
    return const CreateMomentState();
  }


  void updateCaption(String value) {
    state = state.copyWith(
      caption:value,
    );
  }


  void addMedia(String path) {
    state = state.copyWith(
      mediaPaths:[
        ...state.mediaPaths,
        path,
      ],
    );
  }


  void removeMedia(int index) {
    final list = [
      ...state.mediaPaths,
    ];

    list.removeAt(index);

    state = state.copyWith(
      mediaPaths:list,
    );
  }


  void updateLocation(String? location) {
    state = state.copyWith(
      location:location,
    );
  }


  void toggleVisibility() {
    state = state.copyWith(
      isPublic:
      !state.isPublic,
    );
  }


  void addVoice(String path) {
    state = state.copyWith(
      voicePath:path,
    );
  }


  Future<bool> publish({
    required Moment moment,
  }) async {

    state = state.copyWith(
      isLoading:true,
    );

    try {

      await repository.createMoment(
        moment:moment,
        mediaPaths:state.mediaPaths,
      );

      state = const CreateMomentState();

      return true;

    } catch(e) {

      return false;

    } finally {

      state = state.copyWith(
        isLoading:false,
      );

    }
  }
}