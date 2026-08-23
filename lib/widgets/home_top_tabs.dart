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
      "Party",
    ];


    return Padding(

      padding:
      const EdgeInsets.symmetric(horizontal:15),

      child: Row(

        children:[


          Expanded(

            child: Container(

              height:38,


              padding:
              const EdgeInsets.all(3),


              decoration:BoxDecoration(

                color:
                Colors.white.withValues(alpha:.06),


                borderRadius:
                BorderRadius.circular(22),


                border:Border.all(

                  color:
                  Colors.white.withValues(alpha:.10),

                ),

              ),


              child:Row(

                children:

                List.generate(

                  tabs.length,

                      (index){

                    final active =
                        selectedIndex == index;


                    return Expanded(

                      child:GestureDetector(

                        onTap:(){

                          onChanged?.call(index);

                        },


                        child:AnimatedContainer(

                          duration:
                          const Duration(
                            milliseconds:220,
                          ),


                          alignment:
                          Alignment.center,


                          decoration:BoxDecoration(

                            borderRadius:
                            BorderRadius.circular(20),


                            gradient:

                            active

                                ?

                            const LinearGradient(

                              colors:[

                                Color(0xff00D9B5),

                                Color(0xff00A98F),

                              ],

                            )

                                :

                            null,


                            boxShadow:

                            active

                                ?

                            [

                              BoxShadow(

                                color:
                                const Color(0xff00D9B5)
                                    .withValues(alpha:.35),

                                blurRadius:12,

                              ),

                            ]

                                :

                            [],

                          ),


                          child:Text(

                            tabs[index],


                            style:TextStyle(

                              color:

                              active

                                  ?

                              Colors.black

                                  :

                              Colors.white70,


                              fontSize:13,


                              fontWeight:

                              active

                                  ?

                              FontWeight.w700

                                  :

                              FontWeight.w500,

                            ),

                          ),

                        ),

                      ),

                    );

                  },

                ),

              ),

            ),

          ),


          const SizedBox(width:10),


          Container(

            height:38,

            width:38,


            decoration:BoxDecoration(

              color:
              Colors.white.withValues(alpha:.06),


              shape:
              BoxShape.circle,


              border:Border.all(

                color:
                Colors.white.withValues(alpha:.10),

              ),

            ),


            child:const Icon(

              Icons.search_rounded,

              color:Colors.white,

              size:20,

            ),

          ),

        ],

      ),

    );

  }

}