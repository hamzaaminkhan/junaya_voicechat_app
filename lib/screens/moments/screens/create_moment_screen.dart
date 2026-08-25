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
extends ConsumerState<CreateMomentScreen>{


  static const Color purple =
  Color(0xFF9D3BFF);


  static const Color gold =
  Color(0xFFFFD36A);


  final TextEditingController _captionController =
  TextEditingController();


  final ImagePicker _picker =
  ImagePicker();


  final List<XFile> _selectedImages =
  [];


  bool _posting = false;


  @override
  void initState() {
    super.initState();

  }


  @override
  void dispose() {
    _captionController.dispose();

    super.dispose();
  }


  Future<void> _pickImages() async {
    try {
      final List<XFile> images =
      await _picker.pickMultiImage(
        imageQuality: 88,
      );


      if (images.isEmpty) return;


      final int available =
          4 - _selectedImages.length;


      if (available <= 0) {
        _showMessage(
          "Maximum 4 images allowed",
        );

        return;
      }


      setState(() {
        _selectedImages.addAll(
          images.take(
            available,
          ),
        );
      });
    } catch (_) {
      _showMessage(
        "Unable to open gallery",
      );
    }
  }


  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }


  Future<void> _postMoment() async {

    final caption =
    _captionController.text.trim();



    if(
    caption.isEmpty &&
        _selectedImages.isEmpty
    ){

      _message(
        "Add text or photos",
      );

      return;

    }



    setState(() {

      _posting = true;

    });




    try {


      final moment = Moment(

        id:
        generateId(),



        author:

        const MomentUser(

          id:
          "local_user",

          username:
          "junaya",

          displayName:
          "Junaya User",

          avatar:
          "",

        ),



        caption:
        caption,



        // Storage will replace this
        // with saved media

        media:
        const [],



        createdAt:
        DateTime.now(),



        visibility:
        MomentVisibility.public,



        hashtags:
        const [],



        stats:
        const MomentStats(),



        isLiked:
        false,



        reactions:
        const [],



        isPinned:
        false,


      );






      await ref
          .read(
        momentsProvider.notifier,
      )
          .createMoment(

        moment:
        moment,


        imagePaths:

        _selectedImages
            .map(
              (image)=>image.path,
        )
            .toList(),

      );






      if(!mounted) return;



      Navigator.pop(
        context,
      );


    }



    catch(error, stack){


      debugPrint(
        error.toString(),
      );


      debugPrint(
        stack.toString(),
      );


      _message(
        "Failed creating moment",
      );


    }



    finally{


      if(mounted){

        setState(() {

          _posting = false;

        });

      }


    }


  }


  void _showMessage(String message) {
    ScaffoldMessenger.of(context)

      ..hideCurrentSnackBar()

      ..showSnackBar(

        SnackBar(

          content:
          Text(message),

        ),

      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(


      backgroundColor:
      const Color(0xff09000F),


      body:
      Stack(


        children: [


          const Positioned.fill(

            child:
            JunayaBackground(),

          ),


          SafeArea(


            child:
            SingleChildScrollView(


              padding:
              const EdgeInsets.all(18),


              child:
              Column(


                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [


                  _header(),


                  const SizedBox(
                    height: 30,
                  ),


                  _captionBox(),


                  const SizedBox(
                    height: 25,
                  ),


                  _imageSection(),


                ],


              ),


            ),


          ),


        ],


      ),


    );
  }


  Widget _header() {
    return Row(


      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,


      children: [


        IconButton(

          onPressed:
              () => Navigator.pop(context),


          icon:
          const Icon(

            Icons.close,

            color:
            Colors.white,

          ),

        ),


        const Text(

          "Create Moment",

          style:
          TextStyle(

            color:
            gold,

            fontSize:
            25,

            fontWeight:
            FontWeight.bold,

          ),

        ),


        ElevatedButton(

          onPressed:
          _posting
              ?
          null
              :
          _postMoment,


          child:
          _posting

              ?

          const SizedBox(

            width:
            18,

            height:
            18,

            child:
            CircularProgressIndicator(
              strokeWidth: 2,
            ),

          )


              :

          const Text(
            "Post",
          ),


        ),


      ],

    );
  }


  Widget _captionBox() {
    return Container(

      height:
      220,


      decoration:
      BoxDecoration(

        color:
        Colors.black26,


        borderRadius:
        BorderRadius.circular(20),


        border:
        Border.all(

          color:
          purple,

        ),

      ),


      child:
      TextField(

        controller:
        _captionController,


        expands:
        true,


        maxLines:
        null,


        style:
        const TextStyle(

          color:
          Colors.white,

          fontSize:
          17,

        ),


        decoration:
        const InputDecoration(

          hintText:
          "Say something...",


          hintStyle:
          TextStyle(
            color:
            Colors.white54,
          ),


          border:
          InputBorder.none,


          contentPadding:
          EdgeInsets.all(18),


        ),

      ),

    );
  }

  Widget _imageSection() {
    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,


      children: [


        const Text(

          "Photos",

          style:
          TextStyle(

            color:
            Colors.white,

            fontSize:
            18,

            fontWeight:
            FontWeight.bold,

          ),

        ),


        const SizedBox(
          height: 15,
        ),


        GridView.builder(

          shrinkWrap:
          true,


          physics:
          const NeverScrollableScrollPhysics(),


          itemCount:
          _selectedImages.length < 4

              ?

          _selectedImages.length + 1

              :

          4,


          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(

            crossAxisCount:
            2,


            crossAxisSpacing:
            12,


            mainAxisSpacing:
            12,


            childAspectRatio:
            .95,


          ),


          itemBuilder:
              (context, index) {
            if (
            index == _selectedImages.length &&
                _selectedImages.length < 4
            ) {
              return _uploadTile();
            }


            return _imagePreview(
              index,
            );
          },


        ),


        const SizedBox(
          height: 10,
        ),


        Text(

          "${_selectedImages.length}/4 images selected",

          style:
          const TextStyle(

            color:
            Colors.white54,

            fontSize:
            13,

          ),

        ),


      ],

    );
  }


  Widget _uploadTile() {
    return InkWell(

      onTap:
      _pickImages,


      borderRadius:
      BorderRadius.circular(20),


      child:
      Container(


        decoration:
        BoxDecoration(


          color:
          const Color(
            0xff170020,
          ),


          borderRadius:
          BorderRadius.circular(20),


          border:
          Border.all(

            color:
            const Color(
              0xffD27AFF,
            ),


            width:
            1.5,

          ),


        ),


        child:
        Column(


          mainAxisAlignment:
          MainAxisAlignment.center,


          children: [


            Container(

              width:
              70,


              height:
              55,


              decoration:
              BoxDecoration(


                borderRadius:
                BorderRadius.circular(12),


                border:
                Border.all(

                  color:
                  gold,

                  width:
                  2,

                ),


              ),


              child:
              const Icon(

                Icons.add_photo_alternate_outlined,


                color:
                gold,


                size:
                32,


              ),


            ),


            const SizedBox(
              height: 12,
            ),


            const Text(

              "Add photo",

              style:
              TextStyle(

                color:
                Colors.white70,


              ),


            ),


          ],


        ),


      ),


    );
  }


  Widget _imagePreview(int index,) {
    final XFile image =
    _selectedImages[index];


    return Stack(


      children: [


        Positioned.fill(


          child:
          ClipRRect(


            borderRadius:
            BorderRadius.circular(20),


            child:
            Image.file(


              File(
                image.path,
              ),


              fit:
              BoxFit.cover,


              errorBuilder:
                  (_, _, _) {
                return Container(

                  color:
                  Colors.black26,


                  child:
                  const Icon(

                    Icons.broken_image_outlined,


                    color:
                    Colors.white54,


                  ),


                );
              },


            ),


          ),


        ),


        Positioned.fill(


          child:
          Container(


            decoration:
            BoxDecoration(


              borderRadius:
              BorderRadius.circular(20),


              border:
              Border.all(


                color:
                purple,


                width:
                1.5,


              ),


            ),


          ),


        ),


        Positioned(


          top:
          8,


          right:
          8,


          child:
          GestureDetector(


            onTap:
                () =>
                _removeImage(
                  index,
                ),


            child:
            Container(


              width:
              34,


              height:
              34,


              decoration:
              BoxDecoration(


                shape:
                BoxShape.circle,


                color:
                Colors.black.withValues(
                  alpha: .65,
                ),


                border:
                Border.all(

                  color:
                  gold,

                ),


              ),


              child:
              const Icon(

                Icons.close_rounded,


                color:
                Colors.white,


                size:
                20,


              ),


            ),


          ),


        ),


      ],


    );
  }

  void _message(String s) {}

}

class JunayaBackground extends StatelessWidget {

  const JunayaBackground({
    super.key,
  });



  @override
  Widget build(BuildContext context) {


    return CustomPaint(

      painter:
      _JunayaBackgroundPainter(),


      child:
      Container(

        decoration:
        const BoxDecoration(

          gradient:
          LinearGradient(

            begin:
            Alignment.topCenter,


            end:
            Alignment.bottomCenter,


            colors:[

              Color(0xff09000F),

              Color(0xff140021),

            ],

          ),

        ),

      ),


    );


  }

}







class _JunayaBackgroundPainter
    extends CustomPainter {



  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {



    final double bottom =
        size.height - 90;





    final Paint glowPaint =
    Paint()

      ..style =
          PaintingStyle.stroke


      ..strokeWidth =
      18


      ..color =
      const Color(
        0xff9D3BFF,
      ).withValues(
        alpha:0.15,
      )


      ..maskFilter =
      const MaskFilter.blur(
        BlurStyle.normal,
        20,
      );






    final Paint purplePaint =
    Paint()

      ..style =
          PaintingStyle.stroke


      ..strokeWidth =
      2


      ..color =
      const Color(
        0xff9D3BFF,
      ).withValues(
        alpha:.55,
      );






    final Paint goldPaint =
    Paint()

      ..style =
          PaintingStyle.stroke


      ..strokeWidth =
      1.5


      ..color =
      const Color(
        0xffffd36a,
      ).withValues(
        alpha:.8,
      );







    final Path leftWave =
    Path()


      ..moveTo(
        -50,
        bottom,
      )


      ..quadraticBezierTo(

        size.width * .25,

        bottom - 100,

        size.width * .50,

        bottom,

      );







    final Path rightWave =
    Path()


      ..moveTo(

        size.width + 50,

        bottom,

      )


      ..quadraticBezierTo(

        size.width * .75,

        bottom - 100,

        size.width * .50,

        bottom,

      );






    canvas.drawPath(
      leftWave,
      glowPaint,
    );


    canvas.drawPath(
      rightWave,
      glowPaint,
    );







    for(
    int i = 0;
    i < 5;
    i++
    ){


      final double offset =
          i * 12;



      final Path left =
      Path()


        ..moveTo(

          -30,

          bottom - offset,

        )


        ..quadraticBezierTo(

          size.width * .20,

          bottom - 70 - offset,

          size.width * .50,

          bottom - offset,

        );







      final Path right =
      Path()


        ..moveTo(

          size.width + 30,

          bottom - offset,

        )


        ..quadraticBezierTo(

          size.width * .80,

          bottom - 70 - offset,

          size.width * .50,

          bottom - offset,

        );





      canvas.drawPath(

        left,

        i == 1
            ?
        goldPaint
            :
        purplePaint,

      );



      canvas.drawPath(

        right,

        i == 1
            ?
        goldPaint
            :
        purplePaint,

      );


    }







    final Paint particlePaint =
    Paint()
      ..color =
      const Color(
        0xffffd36a,
      );





    for(
    int i = 0;
    i < 30;
    i++
    ){



      final double x =
      i.isEven

          ?

      20 + (i * 5)

          :

      size.width - (i * 5);





      final double y =
          100 + ((i * 19) % 220);





      canvas.drawCircle(

        Offset(
          x,
          y,
        ),


        i % 3 == 0
            ?
        2
            :
        1,


        particlePaint,

      );



    }




  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ){

    return false;

  }


}