import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class EditProfileDetailsScreen extends StatelessWidget {

  const EditProfileDetailsScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,


      body: Stack(

        children: [


          // SPACE BACKGROUND

          Positioned.fill(

            child: Image.asset(

              "assets/backgrounds/space_bg.jpeg",

              fit: BoxFit.cover,

            ),

          ),



          // DARK OVERLAY

          Positioned.fill(

            child: Container(

              color: Colors.black.withOpacity(.35),

            ),

          ),





          SafeArea(

            child: Column(

              children: [



                // TOP BAR

                Padding(

                  padding: const EdgeInsets.symmetric(

                    horizontal: 15,

                    vertical: 10,

                  ),


                  child: Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,


                    children: [



                      IconButton(

                        icon: const Icon(

                          Icons.arrow_back,

                          color: Colors.white,

                          size: 30,

                        ),


                        onPressed: () {

                          Navigator.pop(context);

                        },

                      ),





                      Text(

                        "Edit Profile",

                        style:
                        GoogleFonts.poppins(

                          color: Colors.white,

                          fontSize: 20,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),





                      TextButton(

                        onPressed: () {

                          Navigator.pop(context);

                        },


                        child: Text(

                          "Save",

                          style:
                          GoogleFonts.poppins(

                            color: Colors.amber,

                            fontSize: 16,

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),

                      ),



                    ],

                  ),

                ),







                const SizedBox(height: 20),







                // PROFILE IMAGE

                Container(

                  padding:
                  const EdgeInsets.all(4),


                  decoration: BoxDecoration(

                    shape: BoxShape.circle,


                    border: Border.all(

                      color:
                      Colors.purpleAccent,

                      width: 3,

                    ),

                  ),



                  child: const CircleAvatar(

                    radius: 65,


                    backgroundColor:
                    Color(0xff21152E),



                    child: Icon(

                      Icons.person,

                      size: 70,

                      color: Colors.white,

                    ),

                  ),

                ),







                const SizedBox(height: 15),






                Text(

                  "Change Avatar",

                  style:
                  GoogleFonts.poppins(

                    color: Colors.amber,

                    fontSize: 15,

                  ),

                ),






                const SizedBox(height: 30),







                // TABS

                Container(

                  margin:
                  const EdgeInsets.symmetric(

                    horizontal: 20,

                  ),


                  height: 50,


                  decoration: BoxDecoration(

                    color:
                    Colors.black.withOpacity(.35),


                    borderRadius:
                    BorderRadius.circular(25),


                    border: Border.all(

                      color:
                      Colors.purpleAccent
                          .withOpacity(.5),

                    ),

                  ),




                  child: Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,


                    children: [



                      _tab(
                        "Profile",
                        true,
                      ),


                      _tab(
                        "Props",
                        false,
                      ),


                      _tab(
                        "Post",
                        false,
                      ),



                    ],

                  ),

                ),





                const SizedBox(height: 20),






                Expanded(

                  child: SingleChildScrollView(

                    child: Column(

                      children: [



                        // NEXT PART WILL ADD PROFILE DETAILS


                        _profileDetails(),

                        const SizedBox(height: 30),

                        _supporterSection(),

                        const SizedBox(height: 30),

                        _relationshipSection(),

                        const SizedBox(height: 30),

                        _medalSection(),

                        const SizedBox(height: 40),

                      ],

                    ),

                  ),

                ),



              ],

            ),

          ),



        ],

      ),

    );

  }







  Widget _tab(

      String title,

      bool active,

      ) {


    return Container(

      padding:
      const EdgeInsets.symmetric(

        horizontal: 25,

      ),


      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children: [



          Text(

            title,

            style:
            GoogleFonts.poppins(

              color: active
                  ? Colors.white
                  : Colors.white54,

              fontWeight:
              active
                  ? FontWeight.bold
                  : FontWeight.normal,

            ),

          ),




          if(active)

            Container(

              margin:
              const EdgeInsets.only(

                top: 5,

              ),


              height: 3,


              width: 35,


              decoration: BoxDecoration(

                color:
                Colors.purpleAccent,


                borderRadius:
                BorderRadius.circular(5),

              ),

            ),



        ],

      ),

    );

  }

  Widget _profileDetails() {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),


      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [



          // NAME ROW

          Row(

            children: [


              Text(

                "MR. ALEX",

                style:
                GoogleFonts.poppins(

                  color: Colors.white,

                  fontSize: 28,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              const SizedBox(width: 8),



              const Icon(

                Icons.male,

                color:
                Colors.blueAccent,

                size: 30,

              ),




              const SizedBox(width: 10),




              _smallBadge(

                Icons.workspace_premium,

                "0",

                Colors.orange,

              ),




              const SizedBox(width: 8),




              _smallBadge(

                Icons.diamond,

                "0",

                Colors.pinkAccent,

              ),



            ],

          ),






          const SizedBox(height: 15),





          // ID + COUNTRY

          Row(

            children: [



              Text(

                "ID:137804327",

                style:
                GoogleFonts.poppins(

                  color:
                  Colors.white70,

                  fontSize: 16,

                ),

              ),




              const SizedBox(width: 8),




              const Icon(

                Icons.copy,

                color:
                Colors.white70,

                size: 20,

              ),





              const SizedBox(width: 15),




              const Text(

                "|",

                style:
                TextStyle(

                  color:
                  Colors.white54,

                  fontSize: 22,

                ),

              ),





              const SizedBox(width: 15),




              const Text(

                "🇵🇰  Pakistan",

                style:
                TextStyle(

                  color:
                  Colors.white,

                  fontSize: 16,

                ),

              ),



            ],

          ),






          const SizedBox(height: 20),






          // WEIGHT

          Row(

            children: [


              Container(

                height: 35,

                width: 35,


                decoration: BoxDecoration(

                  color:
                  Colors.black.withOpacity(.3),


                  borderRadius:
                  BorderRadius.circular(8),


                  border: Border.all(

                    color:
                    Colors.purpleAccent,

                  ),

                ),


                child: const Icon(

                  Icons.monitor_weight,

                  color:
                  Colors.white70,

                  size: 20,

                ),

              ),



              const SizedBox(width: 12),




              Text(

                "64 kg",

                style:
                GoogleFonts.poppins(

                  color:
                  Colors.white70,

                  fontSize: 17,

                ),

              ),



            ],

          ),



        ],

      ),

    );

  }

  Widget _smallBadge(

      IconData icon,

      String text,

      Color color,

      ) {


    return Container(

      padding:
      const EdgeInsets.symmetric(

        horizontal: 12,

        vertical: 5,

      ),


      decoration: BoxDecoration(

        color:
        color,

        borderRadius:
        BorderRadius.circular(20),

      ),


      child: Row(

        children: [


          Icon(

            icon,

            size: 14,

            color:
            Colors.white,

          ),



          const SizedBox(width: 4),



          Text(

            text,

            style:
            const TextStyle(

              color:
              Colors.white,

              fontWeight:
              FontWeight.bold,

            ),

          ),


        ],

      ),

    );


  }

  Widget _supporterSection() {


    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),


      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [


          // TITLE ROW

          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,


            children: [


              Text(

                "Supporter",

                style:
                GoogleFonts.poppins(

                  color: Colors.white,

                  fontSize: 22,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              Row(

                children: [


                  Text(

                    "Ranking",

                    style:
                    GoogleFonts.poppins(

                      color:
                      Colors.white70,

                      fontSize: 16,

                    ),

                  ),



                  const Icon(

                    Icons.arrow_forward_ios,

                    color:
                    Colors.white70,

                    size: 16,

                  ),



                ],

              ),



            ],

          ),




          const SizedBox(height: 20),





          // MEDALS ROW

          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceAround,


            children: [


              _medalItem(

                Colors.amber,

                Icons.weekend,

              ),



              _medalItem(

                Colors.grey,

                Icons.weekend,

              ),




              _medalItem(

                Colors.orange,

                Icons.weekend,

              ),




              _medalItem(

                Colors.deepOrange,

                Icons.weekend,

              ),



            ],

          ),



        ],

      ),

    );

  }

  Widget _medalItem(

      Color color,

      IconData icon,

      ) {


    return Container(

      height: 75,

      width: 75,


      decoration: BoxDecoration(

        shape:
        BoxShape.circle,


        gradient:
        LinearGradient(

          colors: [

            color,

            color.withOpacity(.5),

          ],

        ),



        border: Border.all(

          color:
          Colors.white24,

          width: 2,

        ),



        boxShadow: [


          BoxShadow(

            color:
            color.withOpacity(.4),

            blurRadius: 12,

          )


        ],


      ),



      child: Icon(

        icon,

        color:
        Colors.white70,

        size: 35,

      ),



    );


  }

  Widget _relationshipSection() {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),


      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [


          Text(

            "Special Relationship",

            style:
            GoogleFonts.poppins(

              color: Colors.white,

              fontSize: 22,

              fontWeight:
              FontWeight.bold,

            ),

          ),



          const SizedBox(height: 15),





          // RELATIONSHIP CARD

          Container(

            height: 170,


            width: double.infinity,


            decoration: BoxDecoration(


              color:
              const Color(0xff7A123E)
                  .withOpacity(.75),



              borderRadius:
              BorderRadius.circular(20),



              border: Border.all(

                color:
                Colors.amber,

                width: 2,

              ),



            ),




            child: Stack(

              alignment:
              Alignment.center,


              children: [



                // LEFT PROFILE

                Positioned(

                  left: 35,


                  child: Column(

                    children: [


                      Container(

                        padding:
                        const EdgeInsets.all(3),


                        decoration:
                        BoxDecoration(

                          shape:
                          BoxShape.circle,


                          border: Border.all(

                            color:
                            Colors.amber,

                            width: 3,

                          ),

                        ),



                        child:
                        const CircleAvatar(

                          radius: 38,


                          backgroundColor:
                          Colors.black,


                          child:
                          Icon(

                            Icons.person,

                            color:
                            Colors.white,

                            size: 40,

                          ),

                        ),

                      ),



                      const SizedBox(height: 8),



                      const Text(

                        "MR. ALEX",

                        style:
                        TextStyle(

                          color:
                          Colors.white,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),


                    ],

                  ),

                ),






                // HEART LINE

                const Icon(

                  Icons.favorite,

                  color:
                  Colors.pinkAccent,

                  size: 40,

                ),





                // RIGHT EMPTY PARTNER

                Positioned(

                  right: 45,


                  child: Container(

                    height: 70,

                    width: 70,


                    decoration:
                    BoxDecoration(

                      shape:
                      BoxShape.circle,


                      border: Border.all(

                        color:
                        Colors.amber,

                        width: 3,

                      ),


                      color:
                      Colors.black26,

                    ),



                    child:
                    const Icon(

                      Icons.question_mark,

                      color:
                      Colors.white,

                      size: 35,

                    ),



                  ),

                ),




              ],

            ),


          ),






          const SizedBox(height: 20),





          // EMPTY PROP BOXES

          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,


            children: [


              _emptyPropBox(),

              _emptyPropBox(),

              _emptyPropBox(),



            ],

          ),



        ],

      ),

    );


  }

  Widget _emptyPropBox() {


    return Container(

      height: 120,

      width: 95,


      decoration: BoxDecoration(

        color:
        Colors.black.withOpacity(.25),


        borderRadius:
        BorderRadius.circular(15),


        border: Border.all(

          color:
          Colors.purpleAccent
              .withOpacity(.6),

        ),

      ),



      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children: [


          Container(

            height: 55,

            width: 55,


            decoration:
            BoxDecoration(

              shape:
              BoxShape.circle,


              color:
              Colors.grey.shade700,


            ),

          ),



          const SizedBox(height: 10),



          Container(

            height: 25,

            width: 70,


            decoration:
            BoxDecoration(

              borderRadius:
              BorderRadius.circular(20),


              border: Border.all(

                color:
                Colors.purpleAccent,

              ),

            ),


            child:
            const Icon(

              Icons.add,

              color:
              Colors.white70,

              size: 18,

            ),


          ),



        ],

      ),


    );


  }

  Widget _medalSection() {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),


      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [



          Text(

            "Medal",

            style:
            GoogleFonts.poppins(

              color: Colors.white,

              fontSize: 22,

              fontWeight:
              FontWeight.bold,

            ),

          ),



          const SizedBox(height: 15),




          Container(

            padding:
            const EdgeInsets.all(18),


            decoration: BoxDecoration(

              color:
              Colors.black.withOpacity(.25),


              borderRadius:
              BorderRadius.circular(18),


              border: Border.all(

                color:
                Colors.purpleAccent
                    .withOpacity(.5),

              ),

            ),



            child: Column(

              children: [



                Row(

                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,


                  children: [



                    _medalInfo(

                      "0",

                      "Medal Score",

                    ),




                    Container(

                      height: 45,

                      width: 1,


                      color:
                      Colors.white24,


                    ),




                    _medalInfo(

                      "0",

                      "Rank",

                    ),



                  ],

                ),





                const SizedBox(height: 20),





                Container(

                  height: 80,

                  width: double.infinity,


                  alignment:
                  Alignment.center,


                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white.withOpacity(.05),


                    borderRadius:
                    BorderRadius.circular(14),

                  ),



                  child: Text(

                    "Haven't got a medal yet~",

                    style:
                    GoogleFonts.poppins(

                      color:
                      Colors.white54,

                      fontSize: 15,

                    ),

                  ),

                ),



              ],

            ),

          ),



        ],

      ),

    );

  }

  Widget _medalInfo(

      String number,

      String title,

      ) {


    return Column(

      children: [



        Text(

          number,

          style:
          const TextStyle(

            color:
            Colors.amber,

            fontSize: 24,

            fontWeight:
            FontWeight.bold,

          ),

        ),




        const SizedBox(height: 5),




        Text(

          title,

          style:
          const TextStyle(

            color:
            Colors.white70,

            fontSize: 13,

          ),

        ),



      ],

    );


  }

}