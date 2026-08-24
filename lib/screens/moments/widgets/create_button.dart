import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/create_moment_screen.dart';
import '../providers/moments_provider.dart';



class CreateMomentButton extends ConsumerWidget {

  const CreateMomentButton({
    super.key,
  });



  Future<void> _openCreateScreen(
      BuildContext context,
      WidgetRef ref,
      ) async {


    final bool? created =
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const CreateMomentScreen(),
      ),
    );



    if(created == true) {

      ref
          .read(
        momentsProvider.notifier,
      )
          .refresh();

    }

  }






  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {


    return FloatingActionButton.extended(

      onPressed:

          () => _openCreateScreen(
        context,
        ref,
      ),


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

    );


  }

}