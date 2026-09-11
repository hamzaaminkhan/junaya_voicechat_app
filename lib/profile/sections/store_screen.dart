import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/space_background.dart';

class StoreItem {


  final String name;

  final String image;

  final int price;

  final int duration;

  final String category;



  const StoreItem({

    required this.name,

    required this.image,

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

      name: 'Golden Entrance',

      image:
      'assets/store/entrance_1.png',

      price:
      50000,

      duration:
      7,

      category:
      'Entrance',

    ),



    StoreItem(

      name: 'Royal Entry',

      image:
      'assets/store/entrance_2.png',

      price:
      120000,

      duration:
      7,

      category:
      'Entrance',

    ),




    // ======================================================
    // FRAME
    // ======================================================


    StoreItem(

      name: 'Frame',

      image:
      'assets/store/frame_1.png',

      price:
      15000,

      duration:
      7,

      category:
      'Frame',

    ),



    StoreItem(

      name: 'Rich Man',

      image:
      'assets/store/frame_2.png',

      price:
      250000,

      duration:
      7,

      category:
      'Frame',

    ),



    StoreItem(

      name: 'Blue Shield',

      image:
      'assets/store/frame_3.png',

      price:
      300000,

      duration:
      7,

      category:
      'Frame',

    ),



    StoreItem(

      name: 'Golden Frame',

      image:
      'assets/store/frame_4.png',

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

      name: 'Love Bubble',

      image:
      'assets/store/bubble_1.png',

      price:
      30000,

      duration:
      7,

      category:
      'Bubble Chat',

    ),



    StoreItem(

      name: 'VIP Bubble',

      image:
      'assets/store/bubble_2.png',

      price:
      90000,

      duration:
      7,

      category:
      'Bubble Chat',

    ),




    // ======================================================
    // THEME
    // ======================================================


    StoreItem(

      name: 'Galaxy Theme',

      image:
      'assets/store/theme_1.png',

      price:
      80000,

      duration:
      30,

      category:
      'Theme',

    ),



    StoreItem(

      name: 'Royal Theme',

      image:
      'assets/store/theme_2.png',

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

      height: 55,


      child: Row(

        children: [



          IconButton(

            onPressed: () {

              Navigator.pop(context);

            },


            icon: const Icon(

              Icons.arrow_back_ios_new,

              color: Colors.white,

            ),

          ),




          Expanded(

            child: Row(

              mainAxisAlignment:
              MainAxisAlignment.center,


              children: [



                const Icon(

                  Icons.workspace_premium,

                  color:
                  Color(0xffffd447),

                  size: 28,

                ),




                const SizedBox(
                  width: 8,
                ),




                Text(

                  'Store',

                  style:
                  GoogleFonts.poppins(

                    color: Colors.white,

                    fontSize: 28,

                    fontWeight:
                    FontWeight.w600,

                  ),

                ),


              ],

            ),

          ),





          IconButton(

            onPressed: () {},


            icon: const Icon(

              Icons.checkroom_outlined,

              color:
              Color(0xffffd447),

              size: 30,

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
          horizontal: 28,
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

                    ? const Color(
                  0xff7B1FE8,
                )

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
      const EdgeInsets.all(16),


      itemCount:
      filteredItems.length,


      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount: 2,

        crossAxisSpacing: 14,

        mainAxisSpacing: 16,

        childAspectRatio: .68,

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

      padding:
      const EdgeInsets.all(10),


      decoration:
      BoxDecoration(

        color:
        const Color(0xFF2A1248)
            .withValues(
          alpha: .85,
        ),


        borderRadius:
        BorderRadius.circular(18),


        border:
        Border.all(

          color:
          Colors.white12,

        ),


      ),



      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [



          // ======================================================
          // IMAGE AREA
          // ======================================================


          Expanded(

            child: Container(

              width:
              double.infinity,


              decoration:
              BoxDecoration(


                borderRadius:
                BorderRadius.circular(14),



                color:
                Colors.black
                    .withValues(
                  alpha: .15,
                ),


              ),



              child:
              Stack(

                children: [



                  Center(

                    child:
                    Image.asset(

                      item.image,


                      fit:
                      BoxFit.contain,


                    ),

                  ),




                  Positioned(

                    top:
                    8,


                    right:
                    8,


                    child:
                    Container(

                      padding:
                      const EdgeInsets.symmetric(

                        horizontal:
                        8,

                        vertical:
                        4,

                      ),



                      decoration:
                      BoxDecoration(

                        color:
                        Colors.black54,


                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),

                      ),



                      child:
                      Row(

                        children: [


                          const Icon(

                            Icons.access_time,

                            size:
                            12,

                            color:
                            Colors.white70,

                          ),



                          const SizedBox(
                            width: 3,
                          ),



                          Text(

                            '${item.duration} Days',


                            style:
                            const TextStyle(

                              color:
                              Colors.white,

                              fontSize:
                              10,

                            ),

                          ),


                        ],

                      ),

                    ),

                  ),



                ],

              ),

            ),

          ),





          const SizedBox(
            height: 10,
          ),




          // ======================================================
          // ITEM NAME
          // ======================================================


          Text(

            item.name,


            maxLines:
            1,


            overflow:
            TextOverflow.ellipsis,


            style:
            GoogleFonts.poppins(

              color:
              Colors.white,


              fontSize:
              14,


              fontWeight:
              FontWeight.w600,


            ),

          ),




          const SizedBox(
            height: 8,
          ),




          // ======================================================
          // PRICE + BUY
          // ======================================================


          Row(

            children: [



              Container(

                padding:
                const EdgeInsets.symmetric(

                  horizontal:
                  8,

                  vertical:
                  5,

                ),



                decoration:
                BoxDecoration(

                  color:
                  const Color(
                    0xFFFFD447,
                  ).withValues(
                    alpha: .18,
                  ),



                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),

                ),



                child:
                Row(

                  children: [


                    const Icon(

                      Icons.monetization_on,

                      color:
                      Color(
                        0xFFFFD447,
                      ),

                      size:
                      15,

                    ),



                    const SizedBox(
                      width: 4,
                    ),



                    Text(

                      '${item.price}',


                      style:
                      GoogleFonts.poppins(

                        color:
                        const Color(
                          0xFFFFD447,
                        ),


                        fontSize:
                        11,


                        fontWeight:
                        FontWeight.w600,


                      ),

                    ),



                  ],

                ),

              ),




              const Spacer(),




              SizedBox(

                height:
                32,


                child:
                ElevatedButton(

                  onPressed: () {},


                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    const Color(
                      0xFF8B2BFF,
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


                      fontSize:
                      12,


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