import 'package:flutter/material.dart';

class MomentMediaPicker extends StatefulWidget {
  const MomentMediaPicker({
    super.key,
  });

  @override
  State<MomentMediaPicker> createState() =>
      _MomentMediaPickerState();
}

class _MomentMediaPickerState
    extends State<MomentMediaPicker> {

  final List<String> _media = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff11111A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                "Add photos / videos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                "${_media.length}/10",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height:16),

          SizedBox(
            height:92,
            child: ListView(
              scrollDirection:
              Axis.horizontal,
              children: [

                ..._media.map(
                      (item) {
                    return _mediaItem(item);
                  },
                ),

                if(_media.length < 10)
                  _addButton(),

              ],
            ),
          ),

          const SizedBox(height:14),

          const Text(
            "You can add up to 10 photos or videos",
            style: TextStyle(
              color: Colors.white38,
              fontSize:13,
            ),
          ),

        ],
      ),
    );
  }


  Widget _mediaItem(String image) {
    return Container(
      width:86,
      height:86,
      margin:
      const EdgeInsets.only(right:10),
      decoration:BoxDecoration(
        color:
        const Color(0xff20202A),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child:Stack(
        children:[

          ClipRRect(
            borderRadius:
            BorderRadius.circular(14),
            child:Image.network(
              image,
              width:86,
              height:86,
              fit:BoxFit.cover,
            ),
          ),

          Positioned(
            top:5,
            right:5,
            child:Container(
              width:22,
              height:22,
              decoration:
              const BoxDecoration(
                color:Colors.black54,
                shape:BoxShape.circle,
              ),
              child:const Icon(
                Icons.close,
                size:14,
                color:Colors.white,
              ),
            ),
          ),

        ],
      ),
    );
  }


  Widget _addButton() {
    return GestureDetector(
      onTap:(){

        // Image picker later

      },
      child:Container(
        width:86,
        height:86,
        decoration:BoxDecoration(
          borderRadius:
          BorderRadius.circular(14),
          border:Border.all(
            color:
            const Color(0xffA855F7),
            style:
            BorderStyle.solid,
          ),
          color:
          const Color(0xff0D0D14),
        ),
        child:const Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children:[

            Icon(
              Icons.add,
              color:
              Color(0xffA855F7),
              size:30,
            ),

            Text(
              "Add Media",
              style:TextStyle(
                color:
                Color(0xffC084FC),
                fontSize:12,
              ),
            ),

          ],
        ),
      ),
    );
  }
}