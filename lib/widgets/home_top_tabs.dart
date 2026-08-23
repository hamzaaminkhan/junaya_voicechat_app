import 'package:flutter/material.dart';

class HomeTopTabs extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const HomeTopTabs({
    super.key,
    this.selectedIndex = 0,
    this.onChanged,
  });

  @override
  State<HomeTopTabs> createState() => _HomeTopTabsState();
}

class _HomeTopTabsState extends State<HomeTopTabs>
    with SingleTickerProviderStateMixin {

  final List<String> tabs = [
    "Related",
    "Hot",
    "Party",
  ];

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        Expanded(
          child: Container(
            height: 42,

            padding:
            const EdgeInsets.all(4),

            decoration: BoxDecoration(

              color:
              Colors.white.withValues(alpha: .06),

              borderRadius:
              BorderRadius.circular(24),

              border:
              Border.all(
                color:
                Colors.white.withValues(alpha: .08),
              ),
            ),


            child: Row(

              children:

              List.generate(
                tabs.length,

                    (index){

                  final active =
                      widget.selectedIndex == index;


                  return Expanded(

                    child:
                    GestureDetector(

                      onTap: (){

                        widget.onChanged
                            ?.call(index);

                      },


                      child:
                      AnimatedContainer(

                        duration:
                        const Duration(
                          milliseconds:250,
                        ),

                        curve:
                        Curves.easeOut,

                        alignment:
                        Alignment.center,


                        decoration:
                        BoxDecoration(

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
                        ),


                        child:
                        AnimatedDefaultTextStyle(

                          duration:
                          const Duration(
                            milliseconds:200,
                          ),

                          style:

                          TextStyle(

                            color:

                            active

                                ?
                            Colors.black

                                :
                            Colors.white70,


                            fontSize:
                            14,


                            fontWeight:

                            active

                                ?
                            FontWeight.w700

                                :
                            FontWeight.w500,
                          ),


                          child:
                          Text(
                            tabs[index],
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


        const SizedBox(width:12),


        GestureDetector(

          onTap: (){

            // open search page

          },


          child:
          Container(

            height:42,

            width:42,


            decoration:
            BoxDecoration(

              color:
              Colors.white.withValues(alpha: .06),


              shape:
              BoxShape.circle,


              border:
              Border.all(

                color:
                Colors.white.withValues(alpha: .1),

              ),
            ),


            child:
            const Icon(

              Icons.search_rounded,

              color:
              Colors.white,

              size:22,
            ),
          ),
        ),
      ],
    );
  }
}