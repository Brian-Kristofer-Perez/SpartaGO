
import 'package:sparta_go/repositories/FacilityRepository.dart';

class FacilityService {

  FacilityRepository facilities = FacilityRepository();

  Future<List<Map<String, dynamic>>> get_all() async {
    return facilities.getAll();
  }
}