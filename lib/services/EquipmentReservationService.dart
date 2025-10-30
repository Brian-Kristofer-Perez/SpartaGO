

import 'package:sparta_go/repositories/EquipmentRepository.dart';
import 'package:sparta_go/repositories/EquipmentReservationRepository.dart';
import 'package:sparta_go/services/AutoIncrementService.dart';

class EquipmentReservationService {

  EquipmentRepository equipments = EquipmentRepository();
  EquipmentReservationRepository reservations  = EquipmentReservationRepository();

  void reserve_equipment(int equipment_id, int count, String user_id, DateTime start_date, DateTime end_date ) async {
    final Map<String, dynamic>? equipment = await equipments.getById(
        equipment_id);

    if (equipment == null) {
      throw Exception('equipment not found');
    }

    if (equipment['available'] <= count) {
      throw Exception('not enough equipment available');
    }


    Map<String, dynamic> new_reservation = {
      "id": AutoIncrementService().getNextId('equipment_reservation'),
      "userId": user_id,
      "equipmentId": equipment_id,
      "count": count,
      "startDate": "${start_date.year}-${start_date.month}-${start_date.day}",
      "endDate": "${end_date.year}-${end_date.month}-${end_date.day}"
    };


    reservations.add(new_reservation);
  }
}