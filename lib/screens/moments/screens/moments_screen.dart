import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/media_pipeline_provider.dart';
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



    final pipeline = ref.read(

      mediaPipelineProvider,

    );





    final bool? created =

    await Navigator.push(


      context,


      MaterialPageRoute(


        builder: (_) =>


            CreateMomentScreen(

              pipeline:

              pipeline,

            ),


      ),


    );







    if(created == true){


      ref

          .read(

        momentsProvider.notifier,

      )

          .refresh();


    }


  }








  Future<void> _deleteMoment(

      WidgetRef ref,

      Moment moment,

      ) async {



    await ref

        .read(

      momentsProvider.notifier,

    )

        .deleteMoment(

      moment.id,

    );


  }









  @override

  Widget build(

      BuildContext context,

      WidgetRef ref,

      ) {



    final momentsState =

    ref.watch(

      momentsProvider,

    );







    return Scaffold(



      backgroundColor:

      const Color(0xff090909),





      appBar:

      AppBar(


        backgroundColor:

        Colors.transparent,


        elevation:

        0,



        title:

        const Text(

          "Moments",

          style:

          TextStyle(

            color: Colors.white,

            fontWeight:

            FontWeight.bold,

          ),

        ),


      ),







      floatingActionButton:


      CreateMomentButton(


        onPressed:


            () => _createMoment(

          context,

          ref,

        ),


      ),







      body:


      momentsState.when(



        loading:

            () => const Center(


          child:

          CircularProgressIndicator(),


        ),







        error:

            (error, stackTrace) => Center(


          child:

          Text(


            "Failed loading moments",


            style:

            const TextStyle(

              color:

              Colors.white,

            ),


          ),


        ),








        data:

            (moments) {



          if(moments.isEmpty){


            return _emptyState();


          }







          return RefreshIndicator(



            onRefresh:


                () => ref

                .read(

              momentsProvider.notifier,

            )

                .refresh(),





            child:

            ListView.builder(



              padding:

              const EdgeInsets.only(


                top:

                10,


                bottom:

                100,


              ),





              itemCount:

              moments.length,







              itemBuilder:


                  (context,index){



                final moment =

                moments[index];







                return MomentCard(



                  moment:

                  moment,





                  onDelete:


                      () => _deleteMoment(

                    ref,

                    moment,

                  ),


                );


              },


            ),


          );


        },


      ),


    );


  }









  Widget _emptyState(){



    return Center(


      child:

      Column(


        mainAxisAlignment:

        MainAxisAlignment.center,



        children:[



          const Icon(


            Icons.auto_awesome,


            size:

            80,


            color:

            Colors.purpleAccent,


          ),





          const SizedBox(


            height:

            20,


          ),





          const Text(


            "No moments yet",


            style:

            TextStyle(


              color:

              Colors.white,


              fontSize:

              20,


              fontWeight:

              FontWeight.bold,


            ),


          ),





          const SizedBox(


            height:

            8,


          ),





          const Text(


            "Create your first memory",


            style:

            TextStyle(


              color:

              Colors.white54,


            ),


          ),



        ],


      ),


    );


  }


}