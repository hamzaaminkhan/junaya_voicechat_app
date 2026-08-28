import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/screens/create_moment_screen.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/create_button.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_card.dart';

class MomentsScreen extends ConsumerWidget {
  const MomentsScreen({
    super.key,
  });

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
        .deleteMoment(
      moment.id,
    );
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ){

    final state = ref.watch(
      momentsProvider,
    );

    return Scaffold(
      backgroundColor: const Color(0xff090909),

      floatingActionButton: CreateMomentButton(
        onPressed: (){
          _createMoment(
            context,
            ref,
          );
        },
      ),

      bottomNavigationBar: _bottomBar(),

      body: SafeArea(
        child: Column(
          children: [

            _header(),

            Expanded(
              child: state.when(

                loading: (){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },

                error: (error,stack){
                  return Center(
                    child: TextButton(
                      onPressed: (){
                        ref
                            .read(momentsProvider.notifier)
                            .refresh();
                      },
                      child: const Text(
                        "Retry",
                      ),
                    ),
                  );
                },

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
                        top: 8,
                        bottom: 120,
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
                                .read(
                              momentsProvider.notifier,
                            )
                                .toggleLike(
                              moment,
                            );
                          },

                          onComment: (){},

                          onShare: (){
                            ref
                                .read(
                              momentsProvider.notifier,
                            )
                                .incrementShares(
                              moment.id,
                            );
                          },

                          onSave: (){
                            ref
                                .read(
                              momentsProvider.notifier,
                            )
                                .toggleSave(
                              moment,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(){

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        12,
      ),

      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  "Moments ✨",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                const Text(
                  "Real stories. Real people. Real moments.",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 15,
                  ),
                ),

              ],
            ),
          ),

          Container(
            width: 55,
            height: 55,

            decoration: BoxDecoration(
              color: const Color(0xff171321),
              borderRadius: BorderRadius.circular(18),
            ),

            child: const Icon(
              Icons.tune,
              color: Colors.white70,
              size: 26,
            ),
          ),

        ],
      ),
    );
  }

  Widget _bottomBar(){

    return Container(
      height: 80,

      decoration: BoxDecoration(
        color: const Color(0xff101010),

        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),

        border: Border.all(
          color: Colors.white10,
        ),
      ),

      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [

          Icon(
            Icons.home_outlined,
            color: Colors.white54,
          ),

          Icon(
            Icons.auto_awesome,
            color: Colors.purpleAccent,
          ),

          Icon(
            Icons.mic_none,
            color: Colors.white54,
          ),

          Icon(
            Icons.chat_bubble_outline,
            color: Colors.white54,
          ),

          Icon(
            Icons.person_outline,
            color: Colors.white54,
          ),

        ],
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