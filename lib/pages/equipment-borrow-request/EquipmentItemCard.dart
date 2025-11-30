import 'package:flutter/material.dart';
import 'package:sparta_go/common/calendar/calendar.dart';
import 'dart:convert';
import 'dart:typed_data';

class EquipmentItemCard extends StatelessWidget{

  final Map<String, dynamic> equipment;

  EquipmentItemCard({required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: _buildImage(equipment['image']),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipment["name"],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    equipment['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${equipment['available']}/${equipment['total']} available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        width: double.infinity,
        height: 175,
        errorBuilder: (context, error, stackTrace) => Container(
          width: double.infinity,
          height: 175,
          color: Colors.grey[300],
          child: Icon(
            Icons.fitness_center,
            size: 50,
            color: Colors.grey[400],
          ),
        ),
      );
    } catch (e) {
      print('Error decoding base64 image: $e');
      return Container(
        width: double.infinity,
        height: 175,
        color: Colors.grey[300],
        child: Icon(
          Icons.fitness_center,
          size: 50,
          color: Colors.grey[400],
        ),
      );
    }
  }
}