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
        image:'assets/categories/rank.jpeg',
        title:'',
      ),


      CategoryItem(
        image:'assets/categories/couple.jpeg',
        title:'',
      ),


      CategoryItem(
        image:'assets/categories/nearby.jpeg',
        title:'',
      ),


    ];



    return SizedBox(

      height:82,


      child:Padding(

        padding:
        const EdgeInsets.symmetric(
          horizontal:15,
        ),


        child:Row(

          children:

          items.map((item){


            return Expanded(

              child:Padding(

                padding:
                const EdgeInsets.only(
                  right:10,
                ),


                child:GestureDetector(

                  onTap:(){

                    onTap?.call(item);

                  },


                  child:Container(

                    height:82,


                    decoration:BoxDecoration(


                      borderRadius:
                      BorderRadius.circular(18),


                      color:
                      Colors.white.withValues(
                        alpha:.08,
                      ),



                      border:Border.all(

                        color:
                        Colors.white.withValues(
                          alpha:.10,
                        ),

                      ),

                    ),



                    child:Stack(


                      children:[



                        ClipRRect(

                          borderRadius:
                          BorderRadius.circular(18),


                          child:Image.asset(

                            item.image,


                            width:
                            double.infinity,


                            height:
                            double.infinity,


                            fit:
                            BoxFit.cover,


                          ),

                        ),




                        Container(

                          decoration:
                          BoxDecoration(

                            borderRadius:
                            BorderRadius.circular(18),


                            gradient:
                            LinearGradient(

                              begin:
                              Alignment.topCenter,


                              end:
                              Alignment.bottomCenter,


                              colors:[

                                Colors.transparent,

                                Colors.black54,

                              ],

                            ),

                          ),

                        ),





                        Align(

                          alignment:
                          Alignment.bottomCenter,


                          child:Padding(

                            padding:
                            const EdgeInsets.only(
                              bottom:8,
                            ),


                            child:Text(

                              item.title,


                              style:
                              const TextStyle(

                                color:
                                Colors.white,


                                fontSize:13,


                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),

                          ),

                        )


                      ],


                    ),


                  ),

                ),


              ),

            );


          }).toList(),


        ),

      ),

    );


  }

}





class CategoryItem {


  final String image;

  final String title;



  CategoryItem({

    required this.image,

    required this.title,

  });


}