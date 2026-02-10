import '../../core/network/api_helper.dart';
import '../../core/utils/app_logger.dart';
import '../../core/constants/api_constants.dart';
import '../models/branch_list.dart';

class BranchRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<Branch>> getBranches() async {
    try {
      final response = await _apiHelper.get(ApiConstants.branchList);

      if (response.data != null && response.data['status'] == true) {
        final branchList = BranchList.fromJson(response.data);
        return branchList.branches ?? [];
      } else {
        AppLogger.warning('Branch List fetch failed: ${response.error}');
        return [];
      }
    } catch (e) {
      AppLogger.error('BranchRepository Exception: $e');
      rethrow;
    }
  }
}
