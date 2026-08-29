import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/moment_media_picker.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/moment_option_tile.dart';
import 'package:junaya_voicechat_app/screens/moments/create%20moment/widgets/voice_note_tile.dart';


class CreateMomentScreen extends StatefulWidget {
  const CreateMomentScreen({
    super.key,
  });

  @override
  State<CreateMomentScreen> createState() =>
      _CreateMomentScreenState();
}

class _CreateMomentScreenState
    extends State<CreateMomentScreen> {

  final TextEditingController _caption =
  TextEditingController();

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff07070D),
      body: SafeArea(
        child: Column(
          children: [

            _header(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    _profile(),

                    const SizedBox(height:18),

                    _captionBox(),

                    const SizedBox(height:16),

                    const MomentMediaPicker(),

                    const SizedBox(height:16),

                    MomentOptionTile(
                      icon: Icons.location_on,
                      color: const Color(0xffA855F7),
                      title: "Location",
                      value: "Add location",
                    ),

                    MomentOptionTile(
                      icon: Icons.public,
                      color: Colors.greenAccent,
                      title: "Visibility",
                      value: "Public",
                    ),

                    const VoiceNoteTile(),

                  ],
                ),
              ),
            ),

            _shareButton(),
          ],
        ),
      ),
    );
  }


  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal:16,
        vertical:14,
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children:[
          const Icon(
            Icons.close,
            color:Colors.white,
            size:26,
          ),

          const Text(
            "Create Moment",
            style:TextStyle(
              color:Colors.white,
              fontSize:18,
              fontWeight:FontWeight.w700,
            ),
          ),

          Text(
            "Drafts",
            style:TextStyle(
              color:Color(0xffA855F7),
              fontSize:16,
              fontWeight:FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }


  Widget _profile() {
    return Row(
      children:[

        Container(
          width:52,
          height:52,
          decoration:BoxDecoration(
            shape:BoxShape.circle,
            border:Border.all(
              color:Color(0xffA855F7),
              width:2,
            ),
          ),
          child:const CircleAvatar(
            backgroundColor:
            Color(0xff20202A),
            child:Icon(
              Icons.person,
              color:Colors.white54,
            ),
          ),
        ),

        const SizedBox(width:12),

        const Expanded(
          child:Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children:[

              Text(
                "Junaya",
                style:TextStyle(
                  color:Colors.white,
                  fontSize:16,
                  fontWeight:FontWeight.w700,
                ),
              ),

              Text(
                "@junaya",
                style:TextStyle(
                  color:Colors.white54,
                  fontSize:13,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal:14,
            vertical:8,
          ),
          decoration:BoxDecoration(
            color:Color(0xff191923),
            borderRadius:
            BorderRadius.circular(20),
          ),
          child:const Row(
            children:[

              Icon(
                Icons.public,
                color:Colors.white70,
                size:15,
              ),

              SizedBox(width:5),

              Text(
                "Public",
                style:TextStyle(
                  color:Colors.white,
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }


  Widget _captionBox() {
    return Container(
      height:170,
      padding:const EdgeInsets.all(16),
      decoration:BoxDecoration(
        color:const Color(0xff11111A),
        borderRadius:
        BorderRadius.circular(22),
        border:Border.all(
          color:Colors.white10,
        ),
      ),
      child:TextField(
        controller:_caption,
        maxLength:500,
        maxLines:null,
        style:const TextStyle(
          color:Colors.white,
        ),
        decoration:const InputDecoration(
          hintText:
          "What's on your mind?",
          hintStyle:TextStyle(
            color:Colors.white38,
          ),
          border:InputBorder.none,
          counterStyle:TextStyle(
            color:Colors.white38,
          ),
        ),
      ),
    );
  }


  Widget _shareButton() {
    return Padding(
      padding:const EdgeInsets.all(16),
      child:SizedBox(
        width:double.infinity,
        height:56,
        child:ElevatedButton(
          onPressed:(){},
          style:ElevatedButton.styleFrom(
            backgroundColor:
            const Color(0xff8B5CF6),
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(18),
            ),
          ),
          child:const Text(
            "✦  Share Moment",
            style:TextStyle(
              color:Colors.white,
              fontSize:16,
              fontWeight:FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}