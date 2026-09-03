import 'package:flutter/material.dart';

class RoomTopUsers extends StatelessWidget {

  final List<TopRoomUser> users;
  final int totalUsers;

  const RoomTopUsers({
    super.key,
    required this.users,
    required this.totalUsers,
  });


  @override
  Widget build(BuildContext context) {

    final visibleUsers =
    users.take(4).toList();


    final remaining =
        totalUsers - visibleUsers.length;


    return Row(

      mainAxisSize: MainAxisSize.min,

      children: [

        ...visibleUsers.map(
              (user) => Padding(
            padding:
            const EdgeInsets.only(right: -6),

            child: _UserCircle(
              user: user,
            ),
          ),
        ),


        if (remaining > 0)

          Container(

            width: 38,

            height: 38,

            alignment:
            Alignment.center,


            decoration: BoxDecoration(

              color:
              Colors.white.withOpacity(.15),

              shape:
              BoxShape.circle,


              border: Border.all(
                color:
                Colors.white54,
              ),
            ),


            child: Text(
              '+$remaining',

              style:
              const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}



class _UserCircle extends StatelessWidget {

  final TopRoomUser user;


  const _UserCircle({
    required this.user,
  });


  @override
  Widget build(BuildContext context) {

    return Container(

      width: 42,

      height: 42,


      padding:
      const EdgeInsets.all(2),


      decoration:
      BoxDecoration(

        shape:
        BoxShape.circle,


        gradient:
        _rankGradient(
          user.rank,
        ),
      ),


      child:
      CircleAvatar(

        backgroundImage:
        NetworkImage(
          user.avatar,
        ),
      ),
    );
  }



  LinearGradient _rankGradient(int rank) {

    switch(rank){

      case 1:
        return const LinearGradient(
          colors:[
            Color(0xffffd700),
            Color(0xffffa000),
          ],
        );


      case 2:
        return const LinearGradient(
          colors:[
            Color(0xffc0c0c0),
            Color(0xff757575),
          ],
        );


      default:
        return const LinearGradient(
          colors:[
            Color(0xffeeeeee),
            Color(0xff9e9e9e),
          ],
        );
    }
  }
}



class TopRoomUser {

  final String name;

  final String avatar;

  final int rank;


const  TopRoomUser({
    required this.name,
    required this.avatar,
    required this.rank,
  });
}