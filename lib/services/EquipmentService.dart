import '../repositories/EquipmentRepository.dart';

class EquipmentService {
  final EquipmentRepository _repository = EquipmentRepository();

  /// Fetches all equipment from the JSON file
  Future<List<Map<String, dynamic>>> getAllEquipment() async {
    return await _repository.getAll();
  }
}
