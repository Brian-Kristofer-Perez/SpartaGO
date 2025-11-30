import 'package:flutter/material.dart';
import 'package:sparta_go/pages/facility-borrow-request/FacilityBorrowRequestPage.dart';
import 'dart:convert';
import 'dart:typed_data';

class FacilityCard extends StatelessWidget {
  final Map<String, dynamic> facility;
  final Future<void> Function() onRefresh;

  Map<String, dynamic> user;

  FacilityCard({Key? key, required this.facility, required this.onRefresh, required this.user}) : super(key: key);

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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey[300],
              child: _buildImage(facility['image']),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    facility['name'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    facility['description'],
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 8, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          facility['building'],
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.people, size: 8, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Capacity: ${facility['capacity']}',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.check_circle, size: 8, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Available today',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Equipment:',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: facility['equipment'].map<Widget>((equipment) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          equipment,
                          style: TextStyle(
                            fontSize: 5.8,
                            color: Colors.grey[700],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 150,
                    height: 15,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool willReset = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FacilityBorrowRequestPage(
                                  facility: facility,
                                  user: user,
                                )
                            )
                        );

                        if(willReset) {
                          await onRefresh();
                        }
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
                        'Reserve Facility',
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

    Widget _buildImage(String? imageData) {
    if (imageData == null || imageData.isEmpty) {
      return Icon(
        Icons.fitness_center,
        size: 50,
        color: Colors.grey[400],
      );
    }
    try {
      return Image.memory(
        base64Decode(imageData),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.fitness_center,
          size: 50,
          color: Colors.grey[400],
        ),
      );
    } catch (e) {
      print('Error decoding base64 image: $e');
      return Icon(
        Icons.fitness_center,
        size: 50,
        color: Colors.grey[400],
      );
    }
  }
}