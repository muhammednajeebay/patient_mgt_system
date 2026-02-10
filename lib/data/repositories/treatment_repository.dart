import '../../core/network/api_helper.dart';
import '../../core/utils/app_logger.dart';
import '../../core/constants/api_constants.dart';
import '../models/treatment_list.dart';

class TreatmentRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<Treatment>> getTreatments() async {
    try {
      final response = await _apiHelper.get(ApiConstants.treatmentList);

      if (response.data != null && response.data['status'] == true) {
        final treatmentList = TreatmentList.fromJson(response.data);
        return treatmentList.treatments ?? [];
      } else {
        AppLogger.warning('Treatment List fetch failed: ${response.error}');
        return [];
      }
    } catch (e) {
      AppLogger.error('TreatmentRepository Exception: $e');
      rethrow;
    }
  }
}
