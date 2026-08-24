import 'package:flutter/material.dart';
import 'package:junaya_voicechat_app/services/moment_storage.dart';

import '../data/moment_model.dart';
import '../data/moment_repository.dart';
import '../widgets/moment_card.dart';
import 'create_moment_screen.dart';



class MomentsScreen extends StatefulWidget {

  const MomentsScreen({
    super.key,
  });


  @override
  State<MomentsScreen> createState() =>
      _MomentsScreenState();

}



class _MomentsScreenState
    extends State<MomentsScreen> {



  late final MomentRepository repository;


  List<Moment> moments = [];

  bool loading = true;



  @override
  void initState() {

    super.initState();


    repository =
        MomentRepository(
          storage:
          MomentStorage(),
        );


    _loadMoments();

  }





  Future<void> _loadMoments() async {


    setState(() {

      loading = true;

    });



    final result =
    await repository.getMoments();



    if(!mounted) return;



    setState(() {

      moments = result.cast<Moment>();

      loading = false;

    });


  }








  Future<void> _deleteMoment(
      Moment moment,
      ) async {


    await repository
        .deleteMoment(
      moment.id,
    );



    await _loadMoments();


  }








  Future<void> _createMoment() async {


    final bool? created =
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const CreateMomentScreen(),
      ),
    );



    if(created == true){

      _loadMoments();

    }


  }








  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      const Color(0xff090909),



      appBar: AppBar(

        backgroundColor:
        Colors.transparent,


        elevation:0,


        title: const Text(

          "Moments",

          style: TextStyle(
            fontWeight:
            FontWeight.bold,
          ),

        ),


      ),





      floatingActionButton:
      FloatingActionButton.extended(

        onPressed:
        _createMoment,


        backgroundColor:
        Colors.purpleAccent,


        icon:
        const Icon(
          Icons.add,
        ),


        label:
        const Text(
          "Moment",
        ),

      ),








      body:
      RefreshIndicator(


        onRefresh:
        _loadMoments,



        child:

        loading

            ?

        const Center(
          child:
          CircularProgressIndicator(),
        )

            :

        moments.isEmpty

            ?

        _emptyState()



            :

        ListView.builder(

          padding:
          const EdgeInsets.only(
            top:10,
            bottom:100,
          ),


          itemCount:
          moments.length,


          itemBuilder:
              (context,index){


            final moment =
            moments[index];



            return MomentCard(

              moment:
              moment,


              onDelete:
                  ()=>
                  _deleteMoment(
                    moment,
                  ),

            );


          },

        ),



      ),


    );


  }







  Widget _emptyState(){


    return Center(


      child:
      Column(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children:[


          Icon(

            Icons.auto_awesome,

            size:80,

            color:
            Colors.purpleAccent,

          ),



          const SizedBox(
            height:20,
          ),



          const Text(

            "No moments yet",

            style:TextStyle(
              color:Colors.white,
              fontSize:20,
              fontWeight:
              FontWeight.bold,
            ),

          ),



          const SizedBox(
            height:8,
          ),



          const Text(

            "Create your first memory",

            style:TextStyle(
              color:
              Colors.white54,
            ),

          ),


        ],

      ),


    );


  }



}