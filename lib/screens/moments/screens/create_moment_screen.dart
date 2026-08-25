import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:junaya_voicechat_app/screens/moments/data/moment_model.dart';
import 'package:junaya_voicechat_app/screens/moments/providers/moments_provider.dart';



class CreateMomentScreen extends ConsumerStatefulWidget {


  const CreateMomentScreen({

    super.key,

  });



  @override
  ConsumerState<CreateMomentScreen> createState() =>
      _CreateMomentScreenState();


}








class _CreateMomentScreenState

    extends ConsumerState<CreateMomentScreen> {



  final TextEditingController captionController =
  TextEditingController();



  final ImagePicker picker =
  ImagePicker();



  final List<XFile> images = [];



  bool loading = false;









  @override
  void dispose(){


    captionController.dispose();


    super.dispose();

  }









  Future<void> pickImages() async {


    final picked =

    await picker.pickMultiImage(

      imageQuality: 90,

    );



    if(picked.isEmpty){

      return;

    }



    final remaining =

        4 - images.length;



    if(remaining <= 0){

      return;

    }



    setState(() {


      images.addAll(

        picked

            .take(

          remaining,

        ),

      );


    });


  }









  void removeImage(int index){


    setState(() {


      images.removeAt(index);


    });


  }









  Future<void> submit() async {


    final caption =

    captionController.text.trim();





    if(

    caption.isEmpty &&

        images.isEmpty

    ){

      showMessage(
        "Add text or photo",
      );

      return;

    }







    setState(() {


      loading = true;


    });






    try {



      final id =

      DateTime.now()

          .microsecondsSinceEpoch

          .toString();






      final moment =

      Moment(


        id:id,



        author:

        const MomentUser(

          id:

          "local_user",

          username:

          "junaya",

          displayName:

          "Junaya",

          avatar:

          "",

        ),




        caption:

        caption,



        media:

        const [],



        createdAt:

        DateTime.now(),



        visibility:

        MomentVisibility.public,



        hashtags:

        const [],



        stats:

        const MomentStats(

          likes:0,

          comments:0,

          views:0,

        ),



        isLiked:false,



        reactions:

        const [],



        isPinned:false,

      );








      await ref

          .read(

        momentsProvider.notifier,

      )

          .createMoment(

        moment: moment,


        mediaPaths:

        images

            .map(

              (e)=>e.path,

        )

            .toList(),


      );







      if(!mounted){

        return;

      }



      Navigator.pop(

        context,

        true,

      );




    }

    catch(e){


      showMessage(

        "Failed creating moment",

      );


    }



    finally{


      if(mounted){


        setState(() {


          loading=false;


        });


      }


    }


  }









  @override
  Widget build(BuildContext context){


    return Scaffold(


      backgroundColor:

      const Color(0xff090909),




      appBar:

      AppBar(

        backgroundColor:

        Colors.transparent,


        title:

        const Text(

          "Create Moment",

          style:

          TextStyle(

            color:

            Colors.white,

          ),

        ),

      ),







      body:

      Padding(

        padding:

        const EdgeInsets.all(16),



        child:

        Column(

          children:[




            TextField(

              controller:

              captionController,


              maxLines:

              5,



              style:

              const TextStyle(

                color:

                Colors.white,

              ),




              decoration:

              const InputDecoration(

                hintText:

                "Write something...",


                hintStyle:

                TextStyle(

                  color:

                  Colors.white54,

                ),

              ),

            ),







            const SizedBox(

              height:

              20,

            ),






            SizedBox(

              height:

              100,


              child:

              ListView.builder(

                scrollDirection:

                Axis.horizontal,


                itemCount:

                images.length,



                itemBuilder:

                    (_,index){



                  return Stack(

                    children:[



                      Container(

                        width:

                        100,


                        margin:

                        const EdgeInsets.only(

                          right:

                          10,

                        ),



                        decoration:

                        BoxDecoration(

                          borderRadius:

                          BorderRadius.circular(

                            12,

                          ),


                          image:

                          DecorationImage(

                            image:

                            FileImage(

                              File(

                                images[index].path,

                              ),

                            ),



                            fit:

                            BoxFit.cover,


                          ),


                        ),



                      ),






                      Positioned(

                        right:

                        10,

                        child:

                        GestureDetector(

                          onTap:

                              ()=>

                              removeImage(

                                index,

                              ),


                          child:

                          const Icon(

                            Icons.close,

                            color:

                            Colors.white,

                          ),

                        ),

                      )




                    ],

                  );


                },


              ),


            ),







            const Spacer(),






            Row(

              children:[




                IconButton(

                  onPressed:

                  loading

                      ?

                  null

                      :

                  pickImages,


                  icon:

                  const Icon(

                    Icons.image,

                    color:

                    Colors.white,

                  ),

                ),






                const Spacer(),







                ElevatedButton(

                  onPressed:

                  loading

                      ?

                  null

                      :

                  submit,



                  child:

                  loading

                      ?

                  const SizedBox(

                    height:

                    18,

                    width:

                    18,

                    child:

                    CircularProgressIndicator(),

                  )


                      :

                  const Text(

                    "Post",

                  ),

                ),




              ],

            )




          ],

        ),


      ),



    );


  }









  void showMessage(String text){


    ScaffoldMessenger.of(context)

        .showSnackBar(

      SnackBar(

        content:

        Text(text),

      ),

    );


  }



}