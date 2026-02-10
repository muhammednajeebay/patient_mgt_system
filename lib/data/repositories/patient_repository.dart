import '../../core/network/api_helper.dart';
import '../models/patient_list.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/app_logger.dart';

class PatientRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<Patient>> getPatients() async {
    try {
      final response = await _apiHelper.get(ApiConstants.patientList);

      if (response.data != null && response.data['status'] == true) {
        AppLogger.info('Patient List fetched successfully ${response.data}');
        final patientList = PatientList.fromJson(response.data);
        return patientList.patient ?? [];
      } else {
        AppLogger.warning('Patient List fetch failed: ${response.error}');
        return [];
      }
    } catch (e) {
      AppLogger.error('PatientRepository Exception: $e');
      rethrow;
    }
  }
}
