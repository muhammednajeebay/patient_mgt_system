import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://flutter-amr.noviindus.in/api/';

  static const String login = 'Login';
  static const String patientList = 'PatientList';
  static const String patientUpdate = 'PatientUpdate';
  static const String branchList = 'BranchList';
  static const String treatmentList = 'TreatmentList';
}
