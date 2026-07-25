import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:junaya_voicechat_app/screens/settings/settings_screen.dart';
import 'package:junaya_voicechat_app/routes/app_routes.dart';
import 'package:junaya_voicechat_app/widgets/space_background.dart';

class ProfileScreen extends StatelessWidget {
const ProfileScreen({super.key});


@override
Widget build(BuildContext context) {

  return Scaffold(

      backgroundColor: Colors.transparent,

      body: SpaceBackground(

          child: SafeArea(

            child: Stack(

                children: [

 Container(

decoration: const BoxDecoration(

gradient: LinearGradient(

colors: [

Color(0xff080313),
Color(0xff17052A),
Color(0xff080313),

],

begin: Alignment.topCenter,
end: Alignment.bottomCenter,

),

),


child: Column(

children: [


// HEADER

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
      size: 32,
    ),

    onPressed: () {

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
      );

    },
  ),



IconButton(

icon: const Icon(
Icons.edit_square,
color: Colors.amber,
size: 28,
),


onPressed: () {},

),

],

),

),



Expanded(

child: SingleChildScrollView(

child: Column(

children: [

const SizedBox(height: 10),



// PROFILE HEADER

_profileHeader(),


const SizedBox(height: 20),



// STATS

_statsSection(),



const SizedBox(height: 20),



// EDIT PROFILE BUTTON

_editButton(),



const SizedBox(height: 20),



// MENU ITEMS

_menuList(context),



const SizedBox(height: 25),



// LOGOUT

_logoutButton(context),


const SizedBox(height: 25),

],

),

),

),


],

),

),

]
        ),

)
    )
  );

}

// PROFILE HEADER

Widget _profileHeader() {

return Column(

children: [


// Avatar

Container(

padding: const EdgeInsets.all(4),

decoration: BoxDecoration(

shape: BoxShape.circle,

border: Border.all(

color: Colors.amber,

width: 3,

),

),


child: const CircleAvatar(

radius: 58,

backgroundColor: Color(0xff251137),


child: Icon(

Icons.person,

size: 65,

color: Colors.white,

),

),

),



const SizedBox(height: 15),



Row(

mainAxisAlignment:
MainAxisAlignment.center,


children: [


Text(

"MR. ALEX",

style: GoogleFonts.poppins(

color: Colors.white,

fontSize: 26,

fontWeight: FontWeight.bold,

),

),



const SizedBox(width: 5),



const Icon(

Icons.male,

color: Colors.blueAccent,

size: 25,

),

],

),



const SizedBox(height: 5),



Row(

mainAxisAlignment:
MainAxisAlignment.center,


children: [


Text(

"ID : 137804327",

style: GoogleFonts.poppins(

color: Colors.white70,

fontSize: 14,

),

),



const SizedBox(width: 8),



const Icon(

Icons.copy,

size: 16,

color: Colors.white70,

),

],

),



const SizedBox(height: 15),



// VIP BADGE

Container(

padding: const EdgeInsets.symmetric(

horizontal: 22,

vertical: 8,

),


decoration: BoxDecoration(

color: Colors.amber,

borderRadius:
BorderRadius.circular(25),

),


child: const Text(

"VIP 3",

style: TextStyle(

color: Colors.black,

fontWeight: FontWeight.bold,

),

),

),



const SizedBox(height: 20),



// COINS + DIAMONDS


Row(

mainAxisAlignment:
MainAxisAlignment.center,


children: [


_moneyCard(

Icons.monetization_on,

"128,540",

"Coins",

Colors.orange,

),



const SizedBox(width: 15),



_moneyCard(

Icons.diamond,

"12,900",

"Diamonds",

Colors.deepPurpleAccent,

),


],

),

],

);

}





Widget _moneyCard(

IconData icon,

String value,

String title,

Color iconColor,

) {


return Container(

width: 145,

height: 65,


decoration: BoxDecoration(

borderRadius:
BorderRadius.circular(15),


border: Border.all(

color:
Colors.purpleAccent
.withOpacity(.7),

),

color:
const Color(0xff12071F),

),



child: Row(

mainAxisAlignment:
MainAxisAlignment.center,


children: [


Icon(

icon,

color: iconColor,

size: 30,

),



const SizedBox(width: 8),



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

fontWeight:
FontWeight.bold,

fontSize: 16,

),

),



Text(

title,

style: const TextStyle(

color: Colors.white70,

fontSize: 12,

),

),


],

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

Widget _editButton() {

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
Icons.assignment,
"Task",
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
Icons.workspace_premium,
"Privilege",
),



_menuTile(
Icons.help,
"Help",
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
}