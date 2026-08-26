import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/screens/create_moment_screen.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/create_button.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_card.dart';


class MomentsScreen extends ConsumerWidget {

  const MomentsScreen({super.key});


  Future<void> _createMoment(
      BuildContext context,
      WidgetRef ref,
      ) async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateMomentScreen(),
      ),
    );

    if(result == true){
      ref.read(momentsProvider.notifier).refresh();
    }
  }


  Future<void> _deleteMoment(
      WidgetRef ref,
      Moment moment,
      ) async {

    await ref
        .read(momentsProvider.notifier)
        .deleteMoment(moment.id);
  }


  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final state = ref.watch(momentsProvider);

    return Scaffold(
      backgroundColor: const Color(0xff090909),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Moments",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: CreateMomentButton(
        onPressed: () => _createMoment(
          context,
          ref,
        ),
      ),

      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stack) => Center(
          child: TextButton(
            onPressed: () {
              ref
                  .read(momentsProvider.notifier)
                  .refresh();
            },
            child: const Text(
              "Retry",
            ),
          ),
        ),

        data: (moments){

          if(moments.isEmpty){
            return _emptyState();
          }

          return RefreshIndicator(
            onRefresh: (){
              return ref
                  .read(momentsProvider.notifier)
                  .refresh();
            },

            child: ListView.builder(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 100,
              ),

              itemCount: moments.length,

              itemBuilder: (context,index){

                final moment = moments[index];

                return MomentCard(
                  moment: moment,

                  onDelete: (){
                    _deleteMoment(
                      ref,
                      moment,
                    );
                  },

                  onLike: (){
                    ref
                        .read(momentsProvider.notifier)
                        .toggleLike(moment);
                  },

                  onComment: () {},

                  onShare: (){
                    ref
                        .read(momentsProvider.notifier)
                        .incrementShares(
                      moment.id,
                    );
                  },

                  onSave: (){
                    ref
                        .read(momentsProvider.notifier)
                        .toggleSave(moment);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }


  Widget _emptyState(){

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            Icons.auto_awesome,
            color: Colors.purpleAccent,
            size: 70,
          ),

          SizedBox(
            height: 16,
          ),

          Text(
            "No moments yet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(
            height: 8,
          ),

          Text(
            "Create your first memory",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}