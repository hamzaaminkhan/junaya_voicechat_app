import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:junaya_voicechat_app/routes/app_routes.dart';
import 'package:junaya_voicechat_app/screens/home/profile/edit_profile_screen.dart';
import 'package:junaya_voicechat_app/screens/settings/settings_screen.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const ProfileScreen({super.key, this.onBack});

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
      return;
    }

    final navigator = Navigator.of(context);

    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: onBack == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && onBack != null) {
          onBack!();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SpaceBackground(
          child: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xC7080313),
                    Color(0xB817052A),
                    Color(0xC7080313),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () => _handleBack(context),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.edit_square,
                            color: Colors.white,
                            size: 30,
                          ),

                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );

                          },
                        ),

                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _profileHeader(),
                          const SizedBox(height: 20),
                          _statsSection(),
                          const SizedBox(height: 20),
                          _editButton(context),
                          const SizedBox(height: 20),
                          _menuList(context),
                          const SizedBox(height: 25),
                          _logoutButton(context),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// PROFILE HEADER

  Widget _profileHeader() {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      child: Row(

        children: [


          // PROFILE IMAGE

          Container(

            padding: const EdgeInsets.all(3),

            decoration: BoxDecoration(

              shape: BoxShape.circle,

              border: Border.all(

                color: Colors.purpleAccent,

                width: 3,

              ),

            ),


            child: const CircleAvatar(

              radius: 62,

              backgroundImage: AssetImage(
                "assets/users/profile.png",
              ),

            ),

          ),



          const SizedBox(width: 20),



          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [


                // NAME

                Row(

                  children: [


                    Text(

                      "MR. ALEX",

                      style:
                      GoogleFonts.poppins(

                        color: Colors.white,

                        fontSize: 25,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),



                    const SizedBox(width: 5),



                    const Icon(

                      Icons.male,

                      color:
                      Colors.blueAccent,

                      size: 26,

                    ),


                  ],

                ),



                const SizedBox(height: 8),




                // BADGES

                Row(

                  children: [


                    Container(

                      padding:
                      const EdgeInsets.symmetric(

                        horizontal: 14,

                        vertical: 5,

                      ),


                      decoration:
                      BoxDecoration(

                        color:
                        Colors.orange,

                        borderRadius:
                        BorderRadius.circular(20),

                      ),


                      child:
                      const Row(

                        children: [

                          Icon(

                            Icons.workspace_premium,

                            size: 15,

                            color: Colors.white,

                          ),


                          SizedBox(width: 5),


                          Text(

                            "0",

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




                    const SizedBox(width: 8),




                    Container(

                      padding:
                      const EdgeInsets.symmetric(

                        horizontal: 14,

                        vertical: 5,

                      ),


                      decoration:
                      BoxDecoration(

                        color:
                        Colors.pinkAccent,

                        borderRadius:
                        BorderRadius.circular(20),

                      ),


                      child:
                      const Row(

                        children: [


                          Icon(

                            Icons.diamond,

                            size: 15,

                            color: Colors.white,

                          ),


                          SizedBox(width: 5),


                          Text(

                            "0",

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


                  ],

                ),




                const SizedBox(height: 6),




                // ID

                Row(
                  children: [

                    Text(
                      "ID :137804327",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Icon(
                      Icons.copy,
                      color: Colors.white70,
                      size: 16,
                    ),

                  ],
                ),

                const SizedBox(height: 8),

                Row(

                  children: [

                    _headerMoneyCard(
                      Icons.monetization_on,
                      "128,540",
                      "Coins",
                      Colors.orange,
                    ),

                    const SizedBox(width: 8),

                    _headerMoneyCard(
                      Icons.diamond,
                      "12,900",
                      "Diamonds",
                      Colors.purpleAccent,
                    ),

                  ],

                ),


              ],

            ),

          ),


        ],

      ),

    );

  }



// STATS SECTION

  Widget _statsSection() {


    return Container(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 15,
      ),


      padding:
      const EdgeInsets.symmetric(
        vertical: 18,
      ),



      decoration: BoxDecoration(

        borderRadius:
        BorderRadius.circular(18),


        border: Border.all(

          color:
          Colors.purpleAccent
              .withOpacity(.6),

        ),


      ),



      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceAround,


        children: [


          _statItem(
            Icons.person,
            "124",
            "Friends",
          ),



          _statItem(
            Icons.person_add,
            "124",
            "Following",
          ),



          _statItem(
            Icons.groups,
            "124",
            "Followers",
          ),



          _statItem(
            Icons.remove_red_eye,
            "124",
            "Visitors",
          ),


        ],

      ),

    );

  }





  Widget _statItem(

      IconData icon,

      String number,

      String title,

      ) {


    return Column(

      children: [


        Icon(

          icon,

          color: Colors.amber,

          size: 25,

        ),



        const SizedBox(height: 5),



        Text(

          number,

          style: const TextStyle(

            color: Colors.white,

            fontWeight:
            FontWeight.bold,

            fontSize: 16,

          ),

        ),



        Text(

          title,

          style: const TextStyle(

            color: Colors.white70,

            fontSize: 11,

          ),

        ),

      ],

    );

  }

// EDIT PROFILE BUTTON

  Widget _editButton(BuildContext context) {

    return Container(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 15,
      ),


      height: 58,


      decoration: BoxDecoration(

        borderRadius:
        BorderRadius.circular(16),


        border: Border.all(

          color:
          Colors.purpleAccent,

        ),

      ),



      child: InkWell(

        borderRadius:
        BorderRadius.circular(16),


        onTap: () {

// Open edit profile screen later

        },


        child: const Row(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children: [


            Icon(

              Icons.edit,

              color: Colors.amber,

            ),



            SizedBox(width: 10),



            Text(

              "Edit Profile",

              style: TextStyle(

                color: Colors.white,

                fontSize: 17,

              ),

            ),


          ],

        ),

      ),

    );

  }





// MENU LIST

  Widget _menuList(BuildContext context) {


    return Column(

      children: [


        _menuTile(
          Icons.account_balance_wallet,
          "Wallet",
        ),



        _menuTile(
          Icons.shopping_bag,
          "Store",
        ),



        _menuTile(
          Icons.person_add,
          "Invite Friend",
        ),



        _menuTile(
          Icons.handshake,
          "Join Agency",
        ),


        _menuTile(
          Icons.bar_chart,
          "Level",
        ),



        _menuTile(
          Icons.emoji_events,
          "Medal",
        ),



        _menuTile(
          Icons.shield,
          "CP Zone",
        ),


        _menuTile(
          Icons.settings,
          "Setting",
          onTap: () {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (_) =>
                const SettingsScreen(),

              ),

            );

          },
        ),



        _menuTile(
          Icons.language,
          "Language",
        ),



        _menuTile(
          Icons.headset_mic,
          "Help Center",
        ),


      ],

    );

  }





  Widget _menuTile(

      IconData icon,

      String title,

      {

        VoidCallback? onTap,

      }

      ) {


    return Container(

      margin:
      const EdgeInsets.symmetric(

        horizontal: 15,

        vertical: 5,

      ),


      decoration: BoxDecoration(

        color:
        const Color(0xff12071F),


        borderRadius:
        BorderRadius.circular(15),


        border: Border.all(

          color:
          Colors.purpleAccent
              .withOpacity(.45),

        ),

      ),



      child: ListTile(


        leading: Icon(

          icon,

          color: Colors.amber,

        ),



        title: Text(

          title,

          style: GoogleFonts.poppins(

            color: Colors.white,

            fontSize: 15,

          ),

        ),



        trailing: const Icon(

          Icons.arrow_forward_ios,

          color: Colors.white54,

          size: 16,

        ),

        onTap: onTap,

      ),

    );

  }





// LOGOUT BUTTON

  Widget _logoutButton(BuildContext context) {
    return Padding(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 15,
      ),


      child: SizedBox(

        width: double.infinity,


        child: ElevatedButton.icon(


          style:
          ElevatedButton.styleFrom(

            backgroundColor:
            Colors.redAccent,


            padding:
            const EdgeInsets.all(16),


            shape:
            RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(15),

            ),

          ),


          onPressed: () async {
            await FirebaseAuth
                .instance
                .signOut();


            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(

                context,

                AppRoutes.login,

                    (route) => false,

              );
            }
          },


          icon: const Icon(

            Icons.logout,

            color: Colors.white,

          ),


          label: const Text(

            "Logout",

            style: TextStyle(

              color: Colors.white,

              fontSize: 16,

            ),

          ),

        ),

      ),

    );
  }

  Widget _headerMoneyCard(

      IconData icon,

      String value,

      String title,

      Color color,

      ) {

    return Container(

      width: 92,

      height: 38,


      decoration: BoxDecoration(

        color: Colors.black.withOpacity(.35),

        borderRadius:
        BorderRadius.circular(10),

        border: Border.all(

          color:
          Colors.purpleAccent.withOpacity(.5),

          width: 1,

        ),

      ),


      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children: [


          Icon(

            icon,

            color: color,

            size: 18,

          ),


          const SizedBox(width: 4),



          Column(

            mainAxisAlignment:
            MainAxisAlignment.center,


            crossAxisAlignment:
            CrossAxisAlignment.start,


            children: [


              Text(

                value,

                style: const TextStyle(

                  color: Colors.white,

                  fontSize: 10,

                  fontWeight: FontWeight.bold,

                ),

              ),



              Text(

                title,

                style: const TextStyle(

                  color: Colors.white70,

                  fontSize: 8,

                ),

              ),

            ],

          ),

        ],

      ),

    );

  }

}