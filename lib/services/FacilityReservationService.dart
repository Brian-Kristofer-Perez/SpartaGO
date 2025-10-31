import 'package:sparta_go/repositories/FacilityRepository.dart';
import 'package:sparta_go/repositories/FacilityReservationRepository.dart';
import 'package:sparta_go/services/AutoIncrementService.dart';

class FacilityReservationService {

  FacilityReservationRepository reservations = FacilityReservationRepository();
  FacilityRepository facilities = FacilityRepository();

  Future<void> reserve_facility(int user_id, int facility_id, DateTime date, String timeslot) async {

    Map<String, dynamic>? facility = await facilities.getById(facility_id);

    facility!['availableTimeSlots'].remove(timeslot);

    await facilities.update(facility_id, {
      'availableTimeSlots': facility['availableTimeSlots']
    });

    Map<String, dynamic> new_reservation = {
      "id": await AutoIncrementService().getNextId('facility_reservation'),
      "userId": user_id,
      "facilityId": facility_id,
      "date": "${date.year}-${date.month}-${date.day}",
      "timeSlot": timeslot
    };

    await reservations.add(new_reservation);
  }

  Future<List<Map<String, dynamic>>> get_all() async {
    return await reservations.getAll();
  }
}
