import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moments_tab_header.dart';
import 'package:junaya_voicechat_app/screens/moments/widgets/moment_card.dart';



class MomentsScreen extends ConsumerStatefulWidget {

  const MomentsScreen({
    super.key,
  });


  @override
  ConsumerState<MomentsScreen> createState() =>
      _MomentsScreenState();

}



class _MomentsScreenState
    extends ConsumerState<MomentsScreen> {

  int _selectedTab = 1;

  Future<void> _refresh() async {

    await ref
        .read(momentsProvider.notifier)
        .refresh();

  }



  @override
  Widget build(BuildContext context) {


    final momentsAsync =
    ref.watch(momentsProvider);



    return Scaffold(

      backgroundColor: Colors.transparent,


      body: SafeArea(

        bottom: false,


        child: Column(

          children: [



            MomentsTabHeader(
              selectedIndex: _selectedTab,
              onChanged: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
            ),




            Expanded(

              child: RefreshIndicator(

                color:

                const Color(0xffA855F7),


                backgroundColor:

                const Color(0xff151522),


                onRefresh: _refresh,



                child: _selectedTab == 0
                    ? _followingState()
                    : momentsAsync.when(


                  loading: () {

                    return _loading();

                  },



                  error: (error, stack) {

                    return _errorState();

                  },



                  data: (List<Moment> moments) {


                    if (moments.isEmpty) {

                      return _emptyState();

                    }



                    return ListView.builder(


                      physics:

                      const BouncingScrollPhysics(),



                      padding:

                      const EdgeInsets.only(

                        top: 4,

                        bottom: 120,

                      ),



                      itemCount:

                      moments.length,



                      itemBuilder:

                          (context, index) {



                        final Moment moment =
                        moments[index];



                        return TweenAnimationBuilder<double>(


                          tween:

                          Tween(

                            begin: 0,

                            end: 1,

                          ),



                          duration:

                          Duration(

                            milliseconds:

                            250 +

                                (index * 40),

                          ),



                          builder:

                              (context, value, child) {


                            return Opacity(

                              opacity: value,


                              child:

                              Transform.translate(

                                offset:

                                Offset(

                                  0,

                                  12 *

                                      (1 - value),

                                ),


                                child: child,

                              ),

                            );

                          },



                          child: MomentCard(

                            moment: moment,


                            onDelete: () {

                              ref

                                  .read(
                                  momentsProvider
                                      .notifier
                              )

                                  .deleteMoment(

                                moment.id,

                              );

                            },



                            onLike: () {

                              ref

                                  .read(
                                  momentsProvider
                                      .notifier
                              )

                                  .toggleLike(

                                moment,

                              );

                            },



                            onComment: () {



                            },



                            onShare: () {

                              ref

                                  .read(
                                  momentsProvider
                                      .notifier
                              )

                                  .incrementShares(

                                moment.id,

                              );

                            },



                            onSave: () {

                              ref

                                  .read(
                                  momentsProvider
                                      .notifier
                              )

                                  .toggleSave(

                                moment,

                              );

                            },


                          ),

                        );

                      },

                    );

                  },

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }







  Widget _loading() {


    return ListView.builder(

      itemCount: 3,


      padding:

      const EdgeInsets.only(

        top:12,

      ),


      itemBuilder: (_, index) {


        return Container(

          height:300,


          margin:

          const EdgeInsets.symmetric(

            horizontal:14,

            vertical:8,

          ),



          decoration:

          BoxDecoration(

            color:

            const Color(0xff12121A),


            borderRadius:

            BorderRadius.circular(24),

          ),

        );

      },

    );

  }







  Widget _emptyState() {


    return ListView(

      physics:

      const AlwaysScrollableScrollPhysics(),


      children: [


        SizedBox(

          height:

          MediaQuery.of(context).size.height *

              .32,

        ),



        const Center(

          child: Column(

            children: [



              Icon(

                Icons.auto_awesome,

                size:52,

                color:Colors.white30,

              ),



              SizedBox(height:16),



              Text(

                "No moments yet",

                style:TextStyle(

                  color:Colors.white,

                  fontSize:18,

                  fontWeight:FontWeight.w600,

                ),

              ),



              SizedBox(height:6),



              Text(

                "Share your first moment",

                style:TextStyle(

                  color:Colors.white54,

                ),

              ),

            ],

          ),

        ),

      ],

    );

  }







  Widget _errorState() {


    return ListView(

      physics:

      const AlwaysScrollableScrollPhysics(),


      children: [


        SizedBox(

          height:

          MediaQuery.of(context).size.height *

              .35,

        ),



        const Center(

          child: Text(

            "Unable to load moments",

            style:TextStyle(

              color:Colors.white,

            ),

          ),

        ),

      ],

    );

  }

  Widget _followingState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .32,
        ),
        const Center(
          child: Column(
            children: [
              Icon(
                Icons.people_outline,
                size: 52,
                color: Colors.white30,
              ),
              SizedBox(height: 16),
              Text(
                "Following",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Moments from people you follow",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}