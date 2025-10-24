
import 'package:flutter/material.dart';
import 'package:sparta_go/pages/facility-borrow-request/FacilityBorrowRequestWidget.dart';
import 'package:sparta_go/pages/facility-borrow-request/FacilityItemCard.dart';

import '../../common/back_button.dart';

class FacilityBorrowRequestPage extends StatelessWidget {

  // TODO: replace with equipment object
  // final Map<String, dynamic> borrowedItem;
  // BorrowRequestPage({required this.borrowedItem});

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
            SingleChildScrollView(
              child:
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        CustomBackButton(),

                        SizedBox(height: 10,),

                        Center(
                            child: FacilityItemCard(
                              facility:
                                {
                                  'name': 'Basketball Court',
                                  'description': 'Indoor basketball court',
                                  'image': 'assets/images/basketballCourt.jpg',
                                  'building': 'Building A, Level 1',
                                  'capacity': '50 people',
                                  'equipment': ['Basketball', 'Basketball Hoop'],
                                  'type': 'Court',
                                },
                            )
                        ),

                        SizedBox(height: 30,),

                        Center(
                          child: FacilityBorrowRequestWidget(
                            facility: {
                              'name': 'Basketball Court',
                              'description': 'Indoor basketball court',
                              'image': 'assets/images/basketballCourt.jpg',
                              'building': 'Building A, Level 1',
                              'capacity': '50 people',
                              'equipment': ['Basketball', 'Basketball Hoop'],
                              'type': 'Court',
                            },
                          ),
                        )

                      ],
                    )
                )
            )
      );
  }
}