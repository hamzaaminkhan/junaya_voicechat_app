import 'package:flutter/material.dart';

class BannerIndicator extends StatelessWidget {

  final int total;
  final int current;


  const BannerIndicator({

    super.key,

    required this.total,

    required this.current,

  });


  @override
  Widget build(BuildContext context) {

    return Row(

      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(

        total,

            (index){

          return AnimatedContainer(

            duration:
            const Duration(milliseconds:300),

            margin:
            const EdgeInsets.symmetric(horizontal:4),

            width:
            index == current ? 20 : 8,

            height:8,

            decoration:BoxDecoration(

              color:
              index == current

                  ? Colors.amber

                  : Colors.white38,


              borderRadius:
              BorderRadius.circular(10),

            ),

          );

        },

      ),

    );

  }

}