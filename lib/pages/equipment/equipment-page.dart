
import 'package:flutter/material.dart';

class EquipmentPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Gym Facilities",
          style: TextStyle(
            fontSize: 28,
          ),
        ),

        SizedBox(height: 8,),

        Text("Browse and reserve our sports equipment"),

        SizedBox(height: 8,),
        
        // SearchBar(),

        // Tags(),

        GridView.count(
          crossAxisCount: 2,
          children: [
            // GetAllGrid()
          ],
        )
      ],
    );
  }
}