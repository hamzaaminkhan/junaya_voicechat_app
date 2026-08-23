import 'package:flutter/material.dart';


class HomeTopTabs extends StatelessWidget {


  final int selectedIndex;

  final ValueChanged<int>? onChanged;



  const HomeTopTabs({

    super.key,

    this.selectedIndex = 0,

    this.onChanged,

  });




  @override
  Widget build(BuildContext context) {


    final tabs = [

      "Related",

      "Hot",

      "Follow",

    ];



    return Padding(

      padding:
      const EdgeInsets.symmetric(horizontal:18),


      child:Row(

        crossAxisAlignment:
        CrossAxisAlignment.center,


        children:[



          Row(

            children:

            List.generate(

              tabs.length,

                  (index){


                final active =
                    selectedIndex == index;



                return Padding(

                  padding:

                  EdgeInsets.only(

                    right:
                    index == tabs.length-1
                        ? 0
                        : 26,

                  ),



                  child:GestureDetector(

                    onTap:(){

                      onChanged?.call(index);

                    },


                    child:SizedBox(

                      height:35,


                      child:Column(

                        mainAxisAlignment:
                        MainAxisAlignment.center,


                        children:[



                          Text(

                            tabs[index],


                            style:TextStyle(

                              color:

                              active

                                  ?

                              Colors.white

                                  :

                              Colors.white70,


                              fontSize:17,


                              fontWeight:

                              active

                                  ?

                              FontWeight.w800

                                  :

                              FontWeight.w600,

                            ),

                          ),




                          const SizedBox(height:7),




                          AnimatedContainer(

                            duration:
                            const Duration(
                              milliseconds:200,
                            ),


                            height:4,


                            width:

                            active
                                ? 32
                                : 0,


                            decoration:
                            BoxDecoration(

                              color:
                              const Color(
                                0xffC06CFF,
                              ),


                              borderRadius:
                              BorderRadius.circular(20),


                              boxShadow:[


                                BoxShadow(

                                  color:
                                  const Color(
                                    0xffC06CFF,
                                  )
                                      .withValues(
                                    alpha:.7,
                                  ),


                                  blurRadius:10,

                                ),

                              ],

                            ),

                          ),


                        ],

                      ),

                    ),

                  ),

                );


              },

            ),

          ),




          const Spacer(),




          _icon(

            Icons.search_rounded,

          ),



          const SizedBox(width:12),



          _icon(

            Icons.home_rounded,

          ),


        ],

      ),

    );


  }





  Widget _icon(IconData icon){


    return Icon(

      icon,


      color:
      const Color(0xffE2D4FF),


      size:30,


    );


  }


}