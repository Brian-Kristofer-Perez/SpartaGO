
import 'package:flutter/material.dart';
import 'package:sparta_go/pages/equipment-borrow-request/EquipmentBorrowRequestWidget.dart';
import 'package:sparta_go/pages/equipment-borrow-request/EquipmentItemCard.dart';

import '../../common/back_button.dart';

class EquipmentBorrowRequestPage extends StatelessWidget {

  final Map<String, dynamic> equipment;
  EquipmentBorrowRequestPage({required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leadingWidth: 100,
            leading: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 80,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.fitness_center,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ),
        ),
        body:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    CustomBackButton(),

                    SizedBox(height: 10,),

                    Text(
                      "Equipment Borrow Request",
                      style: TextStyle(
                          fontSize: 24
                      ),
                    ),

                    SizedBox(height: 20,),

                    Center(
                      child: EquipmentItemCard(equipment: equipment),
                    ),

                    SizedBox(height: 30,),

                    Center(
                      child: EquipmentBorrowRequestWidget(),
                    )

                  ],
                )
            )
      );
  }
}