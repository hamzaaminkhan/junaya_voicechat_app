import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';


class StoreItem {

  final String name;

  final String asset;

  final bool isLottie;

  final int price;

  final int duration;

  final String category;

  const StoreItem({

    required this.name,

    required this.asset,

    required this.isLottie,

    required this.price,

    required this.duration,

    required this.category,
  });
}

class StoreScreen extends StatefulWidget {

  const StoreScreen({
    super.key,
  });

  @override
  State<StoreScreen> createState() =>
      _StoreScreenState();

}

class _StoreScreenState extends State<StoreScreen> {

  int selectedTab = 1;

  final List<String> tabs = [

    'Entrance',

    'Frame',

    'Bubble Chat',

    'Theme',

  ];

  final List<StoreItem> items = [



// ======================================================
// ENTRANCE
// ======================================================


    StoreItem(
      name: 'Test Golden Frame',
      asset: 'assets/store/frames/test_golden_frame.json',
      isLottie: true,
      price: 15000,
      duration: 7,
      category: 'Frame',
    ),

    StoreItem(

      name:
      'Royal Entry',

      asset:
      'assets/store/entrance/entrance_2.json',

      isLottie:
      true,

      price:
      120000,

      duration:
      7,

      category:
      'Entrance',

    ),





// ======================================================
// FRAMES
// ======================================================


    StoreItem(

      name:
      'Frame',

      asset:
      'assets/store/frames/frame_1.json',

      isLottie:
      true,

      price:
      15000,

      duration:
      7,

      category:
      'Frame',

    ),



    StoreItem(

      name:
      'Rich Man',

      asset:
      'assets/store/frames/frame_2.json',

      isLottie:
      true,

      price:
      250000,

      duration:
      7,

      category:
      'Frame',

    ),



    StoreItem(

      name:
      'Blue Shield',

      asset:
      'assets/store/frames/frame_3.json',

      isLottie:
      true,

      price:
      300000,

      duration:
      7,

      category:
      'Frame',

    ),



    StoreItem(

      name:
      'Golden Frame',

      asset:
      'assets/store/frames/frame_4.json',

      isLottie:
      true,

      price:
      98000,

      duration:
      7,

      category:
      'Frame',

    ),





// ======================================================
// BUBBLE CHAT
// ======================================================


    StoreItem(

      name:
      'Love Bubble',

      asset:
      'assets/store/bubbles/bubble_1.png',

      isLottie:
      false,

      price:
      30000,

      duration:
      7,

      category:
      'Bubble Chat',

    ),



    StoreItem(

      name:
      'VIP Bubble',

      asset:
      'assets/store/bubbles/bubble_2.png',

      isLottie:
      false,

      price:
      90000,

      duration:
      7,

      category:
      'Bubble Chat',

    ),





// ======================================================
// THEMES
// ======================================================


    StoreItem(

      name:
      'Galaxy Theme',

      asset:
      'assets/store/themes/theme_1.png',

      isLottie:
      false,

      price:
      80000,

      duration:
      30,

      category:
      'Theme',

    ),



    StoreItem(

      name:
      'Royal Theme',

      asset:
      'assets/store/themes/theme_2.png',

      isLottie:
      false,

      price:
      150000,

      duration:
      30,

      category:
      'Theme',

    ),


  ];



  final categories = [

    'Entrance',

    'Frame',

    'Bubble Chat',

    'Theme',

  ];



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      Colors.transparent,


      body: SpaceBackground(

        child: SafeArea(

          child: Column(

            children: [


              _buildHeader(),



              const SizedBox(
                height: 15,
              ),



              _buildTabs(),



              const SizedBox(
                height: 18,
              ),



              Expanded(

                child: _buildStoreGrid(),

              ),



            ],

          ),

        ),

      ),

    );

  }





  // =====================================================
  // HEADER
  // =====================================================


  Widget _buildHeader() {

    return SizedBox(

      height: 85,

      child: Row(

        children: [


          // BACK BUTTON

          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/icons/store_back.svg',
              width: 30,
              height: 30,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),




          Expanded(

            child: Row(

              mainAxisAlignment:
              MainAxisAlignment.center,


              children: [



                Container(

                  width: 45,

                  height: 1,

                  color:
                  const Color(0xffffd447),

                ),



                const SizedBox(
                  width: 12,
                ),





                Column(

                  mainAxisAlignment:
                  MainAxisAlignment.center,


                  children: [



                    SvgPicture.asset(
                      'assets/icons/store_crown.svg',
                      width: 28,
                      height: 28,
                      colorFilter: const ColorFilter.mode(
                        Color(0xffffd447),
                        BlendMode.srcIn,
                      ),
                    ),





                    Text(

                      'Store',

                      style:

                      GoogleFonts.poppins(

                        color:
                        Colors.white,


                        fontSize:
                        22,


                        fontWeight:
                        FontWeight.w600,

                      ),

                    ),



                  ],

                ),





                const SizedBox(
                  width: 12,
                ),




                Container(

                  width: 45,

                  height: 1,

                  color:
                  const Color(0xffffd447),

                ),



              ],

            ),

          ),





          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/store_shirt.svg',
              width: 34,
              height: 34,
              colorFilter: const ColorFilter.mode(
                Color(0xffffd447),
                BlendMode.srcIn,
              ),
            ),
          ),
        ],

      ),

    );

  }






  // =====================================================
  // CATEGORY TABS
  // =====================================================


  Widget _buildTabs() {


    return SizedBox(

      height: 42,


      child: ListView.builder(

        scrollDirection:
        Axis.horizontal,


        padding:
        const EdgeInsets.symmetric(
          horizontal: 20,
        ),



        itemCount:
        tabs.length,



        itemBuilder:
            (context,index){


          final active =
              selectedTab == index;



          return GestureDetector(


            onTap: () {


              setState(() {

                selectedTab =
                    index;

              });


            },


            child: AnimatedContainer(

              duration:
              const Duration(
                milliseconds: 200,
              ),


              margin:
              const EdgeInsets.only(
                right: 12,
              ),



              padding:
              const EdgeInsets.symmetric(
                horizontal: 22,
              ),



              alignment:
              Alignment.center,



              decoration:
              BoxDecoration(

                color: active
                    ? const Color(0xff8B2BFF)
                    : Colors.transparent,



                borderRadius:
                BorderRadius.circular(
                  25,
                ),



                border:
                Border.all(

                  color: active

                      ? const Color(
                    0xffffd447,
                  )

                      : Colors.white24,


                ),


              ),



              child: Text(

                tabs[index],


                style:
                GoogleFonts.poppins(

                  color: active

                      ? Colors.white

                      : Colors.white60,


                  fontSize: 14,


                ),

              ),


            ),

          );


        },


      ),

    );


  }

  Widget _buildStoreGrid() {


    final filteredItems =
    items.where((item){

      switch(selectedTab){

        case 0:
          return item.category == 'Entrance';

        case 1:
          return item.category == 'Frame';

        case 2:
          return item.category == 'Bubble Chat';

        case 3:
          return item.category == 'Theme';

        default:
          return false;
      }

    }).toList();



    return GridView.builder(

      padding:
      const EdgeInsets.only(
        left: 22,
        right: 22,
        top: 18,
        bottom: 30,
      ),


      itemCount:
      filteredItems.length,


      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount: 2,

        crossAxisSpacing: 14,

        mainAxisSpacing: 16,

        childAspectRatio: .64,

      ),



      itemBuilder:
          (context,index){


        final item =
        filteredItems[index];


        return _buildStoreCard(item);


      },

    );


  }

  Widget _buildStoreCard(
      StoreItem item,
      ) {

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: const Color(0xff101633)
            .withValues(
          alpha: .60,
        ),

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: const Color(0xff7650B8),
          width: 1.2,
        ),

      ),


      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [


          // ============================
          // IMAGE + DAYS
          // ============================

          Expanded(

            child: Stack(

              children: [


                Center(

                  child: item.isLottie

                      ? Lottie.asset(

                    item.asset,

                    fit: BoxFit.contain,

                    repeat: true,

                  )

                      : Image.asset(

                    item.asset,

                    fit: BoxFit.contain,

                  ),

                ),



                Positioned(

                  top: 2,

                  right: 2,


                  child: Row(

                    children: [

                      const Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 13,
                      ),


                      const SizedBox(
                        width: 3,
                      ),


                      Text(

                        '${item.duration} Days',

                        style:
                        GoogleFonts.poppins(

                          color: Colors.white,

                          fontSize: 11,

                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // ============================
          // NAME
          // ============================
          Text(

            item.name,

            maxLines: 1,

            overflow:
            TextOverflow.ellipsis,

            style:
            GoogleFonts.poppins(

              color: Colors.white,

              fontSize: 16,

              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          // ============================
          // PRICE + BUY
          // ============================
          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: [
                  const Icon(

                    Icons.monetization_on,

                    color:
                    Color(0xffffd447),

                    size: 18,

                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(

                    '${item.price}',


                    style:
                    GoogleFonts.poppins(

                      color:
                      const Color(
                        0xffffd447,
                      ),

                      fontSize: 13,

                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(

                height: 32,


                child:
                OutlinedButton(

                  onPressed: () {},


                  style:
                  OutlinedButton.styleFrom(

                    side:
                    const BorderSide(

                      color:
                      Color(
                        0xffffd447,
                      ),

                    ),


                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),

                    ),


                    padding:
                    const EdgeInsets.symmetric(

                      horizontal: 18,

                    ),

                  ),


                  child:
                  Text(

                    'Buy',


                    style:
                    GoogleFonts.poppins(

                      color:
                      Colors.white,

                      fontSize: 12,

                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}