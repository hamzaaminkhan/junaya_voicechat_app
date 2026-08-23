import 'package:flutter/material.dart';


class CategoryShortcuts extends StatelessWidget {

  final ValueChanged<CategoryItem>? onTap;


  const CategoryShortcuts({
    super.key,
    this.onTap,
  });



  @override
  Widget build(BuildContext context) {


    final items = [

      CategoryItem(
        icon: "🏆",
        title: "Rank",
        color: Color(0xffffc107),
      ),


      CategoryItem(
        icon: "💑",
        title: "Couple",
        color: Color(0xffff6b9d),
      ),


      CategoryItem(
        icon: "📍",
        title: "Nearby",
        color: Color(0xff00d9b5),
      ),


      CategoryItem(
        icon: "🎤",
        title: "Voice",
        color: Color(0xff8b7cff),
      ),

    ];



    return SizedBox(

      height:95,


      child: ListView.builder(

        scrollDirection:
        Axis.horizontal,


        itemCount:
        items.length,


        padding:
        EdgeInsets.zero,


        itemBuilder:
            (context,index){


          final item =
          items[index];



          return Padding(

            padding:
            const EdgeInsets.only(
                right:12),


            child:
            _ShortcutCard(

              item:item,


              onTap:(){

                onTap?.call(item);

              },

            ),

          );

        },

      ),

    );

  }

}






class _ShortcutCard extends StatefulWidget {


  final CategoryItem item;

  final VoidCallback onTap;



  const _ShortcutCard({

    required this.item,

    required this.onTap,

  });



  @override
  State<_ShortcutCard> createState() =>
      _ShortcutCardState();

}




class _ShortcutCardState
    extends State<_ShortcutCard> {


  bool pressed=false;



  @override
  Widget build(BuildContext context){


    return GestureDetector(

      onTapDown:(_){

        setState(() {

          pressed=true;

        });

      },


      onTapCancel:(){

        setState(() {

          pressed=false;

        });

      },


      onTapUp:(_){

        setState(() {

          pressed=false;

        });

        widget.onTap();

      },



      child:

      AnimatedScale(

        scale:
        pressed ? .92 : 1,


        duration:
        const Duration(
            milliseconds:120),


        child:

        Container(

          width:78,


          decoration:
          BoxDecoration(


            color:
            Colors.white.withValues(alpha: .06),


            borderRadius:
            BorderRadius.circular(20),



            border:
            Border.all(

              color:
              Colors.white.withValues(alpha: .08),

            ),


          ),



          child:

          Column(

            mainAxisAlignment:
            MainAxisAlignment.center,


            children:[


              Container(

                height:42,

                width:42,


                alignment:
                Alignment.center,


                decoration:
                BoxDecoration(


                  shape:
                  BoxShape.circle,


                  color:
                  widget.item.color
                      .withValues(alpha: .18),


                ),



                child:

                Text(

                  widget.item.icon,

                  style:
                  const TextStyle(

                    fontSize:22,

                  ),

                ),

              ),



              const SizedBox(
                  height:6),



              Text(

                widget.item.title,


                style:
                const TextStyle(

                  color:
                  Colors.white,


                  fontSize:12,


                  fontWeight:
                  FontWeight.w600,

                ),

              )

            ],

          ),

        ),

      ),

    );

  }

}






class CategoryItem {

  final String icon;

  final String title;

  final Color color;



  CategoryItem({

    required this.icon,

    required this.title,

    required this.color,

  });

}