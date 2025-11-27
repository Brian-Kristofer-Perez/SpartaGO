import 'package:flutter/material.dart';
import 'package:sparta_go/pages/equipment-borrow-request/EquipmentBorrowRequestPage.dart';

class EquipmentCard extends StatelessWidget {
  final Map<String, dynamic> equipment;
  final Future<void> Function() onRefresh;
  final Map<String, dynamic> user;

  const EquipmentCard({Key? key, required this.equipment, required this.onRefresh, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey[300],
              child: Image.asset(
                "assets/images/${equipment['image']}",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.fitness_center,
                  size: 50,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipment['name'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    equipment['description'],
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${equipment['available']}/${equipment['total']} Available',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 150,
                    height: 15,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool mustRefresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EquipmentBorrowRequestPage(equipment: equipment, user: user)
                          )
                        );

                        if (mustRefresh) { await onRefresh(); }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B1E1E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Borrow Equipment',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}