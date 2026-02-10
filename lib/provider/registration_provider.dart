import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/branch_list.dart';
import '../data/models/treatment_list.dart';
import '../data/repositories/branch_repository.dart';
import '../data/repositories/treatment_repository.dart';
import '../data/repositories/patient_repository.dart';
import '../core/utils/app_logger.dart';

class RegistrationProvider with ChangeNotifier {
  final BranchRepository _branchRepository = BranchRepository();
  final TreatmentRepository _treatmentRepository = TreatmentRepository();
  final PatientRepository _patientRepository = PatientRepository();

  List<Branch> _branches = [];
  List<Treatment> _treatments = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  List<Branch> get branches => _branches;
  List<Treatment> get treatments => _treatments;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  // Form State
  String name = '';
  String phone = '';
  String address = '';
  String? selectedLocation;
  Branch? selectedBranch;
  DateTime? selectedDate;
  String selectedHour = '';
  String selectedMinute = '';
  String selectedPaymentMethod = 'Cash';

  final List<SelectedTreatment> _selectedTreatments = [];
  List<SelectedTreatment> get selectedTreatments => _selectedTreatments;

  double totalAmount = 0.0;
  double discountAmount = 0.0;
  double advanceAmount = 0.0;
  double get balanceAmount => totalAmount - discountAmount - advanceAmount;

  Future<void> fetchInitialData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _branchRepository.getBranches(),
        _treatmentRepository.getTreatments(),
      ]);

      _branches = results[0] as List<Branch>;
      _treatments = results[1] as List<Treatment>;

      AppLogger.info(
        'Registration data fetched: ${_branches.length} branches, ${_treatments.length} treatments',
      );
    } catch (e) {
      _error = 'Failed to load data: $e';
      AppLogger.error('RegistrationProvider fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateLocation(String? location) {
    selectedLocation = location;
    notifyListeners();
  }

  void updateBranch(Branch? branch) {
    selectedBranch = branch;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void updateTime({String? hour, String? minute}) {
    if (hour != null) selectedHour = hour;
    if (minute != null) selectedMinute = minute;
    notifyListeners();
  }

  void updatePaymentMethod(String method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  void addTreatment(Treatment treatment, int male, int female) {
    _selectedTreatments.add(
      SelectedTreatment(treatment: treatment, male: male, female: female),
    );
    _calculateTotal();
    notifyListeners();
  }

  void removeTreatment(int index) {
    _selectedTreatments.removeAt(index);
    _calculateTotal();
    notifyListeners();
  }

  void updateTreatment(int index, Treatment treatment, int male, int female) {
    _selectedTreatments[index] = SelectedTreatment(
      treatment: treatment,
      male: male,
      female: female,
    );
    _calculateTotal();
    notifyListeners();
  }

  void _calculateTotal() {
    totalAmount = 0.0;
    for (var selection in _selectedTreatments) {
      final price = double.tryParse(selection.treatment.price ?? '0') ?? 0.0;
      // Note: In the Figma/UI, each treatment card has its own male/female counts.
      // The total amount seems to be the sum of treatment prices added.
      totalAmount += price;
    }
  }

  void updateFinancials({double? discount, double? advance}) {
    if (discount != null) discountAmount = discount;
    if (advance != null) advanceAmount = advance;
    notifyListeners();
  }

  Future<bool> registerPatient(String executiveName) async {
    if (_selectedTreatments.isEmpty) {
      _error = 'Please add at least one treatment';
      notifyListeners();
      return false;
    }
    if (selectedBranch == null) {
      _error = 'Please select a branch';
      notifyListeners();
      return false;
    }
    if (selectedDate == null ||
        selectedHour.isEmpty ||
        selectedMinute.isEmpty) {
      _error = 'Please select date and time';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final dateStr = DateFormat('dd/MM/yyyy').format(selectedDate!);
      final timeStr =
          '$selectedHour:$selectedMinute ${DateTime.now().hour >= 12 ? "PM" : "AM"}';

      final dateTimeFormatted = '$dateStr-$timeStr';

      final List<String> treatmentIds = [];
      final List<String> maleIds = [];
      final List<String> femaleIds = [];

      for (var selection in _selectedTreatments) {
        final id = selection.treatment.id.toString();
        treatmentIds.add(id);
        for (int i = 0; i < selection.male; i++) {
          maleIds.add(id);
        }
        for (int i = 0; i < selection.female; i++) {
          femaleIds.add(id);
        }
      }

      final Map<String, String> data = {
        'name': name,
        'excecutive': executiveName,
        'payment': selectedPaymentMethod,
        'phone': phone,
        'address': address,
        'total_amount': totalAmount.toInt().toString(),
        'discount_amount': discountAmount.toInt().toString(),
        'advance_amount': advanceAmount.toInt().toString(),
        'balance_amount': balanceAmount.toInt().toString(),
        'date_nd_time': dateTimeFormatted,
        'id': '',
        'male': maleIds.join(','),
        'female': femaleIds.join(','),
        'branch': selectedBranch!.id.toString(),
        'treatments': treatmentIds.join(','),
      };

      final response = await _patientRepository.registerPatient(data);

      if (response.isSuccess) {
        AppLogger.success('Patient registered successfully');
        return true;
      } else {
        _error = response.error ?? 'Registration failed';
        AppLogger.warning('Registration failed: $_error');
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      AppLogger.error('RegistrationProvider registerPatient error: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}

class SelectedTreatment {
  final Treatment treatment;
  final int male;
  final int female;

  SelectedTreatment({
    required this.treatment,
    required this.male,
    required this.female,
  });
}
