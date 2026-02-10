import 'package:flutter/material.dart';
import '../data/models/patient_list.dart';
import '../data/repositories/patient_repository.dart';
import '../core/utils/app_logger.dart';

enum PatientSortBy { date, name }

class PatientProvider extends ChangeNotifier {
  final PatientRepository _repository = PatientRepository();

  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  bool _isLoading = false;
  String? _error;
  PatientSortBy _sortBy = PatientSortBy.date;
  String _searchQuery = '';

  List<Patient> get patients => _filteredPatients;
  bool get isLoading => _isLoading;
  String? get error => _error;
  PatientSortBy get sortBy => _sortBy;

  Future<void> fetchPatients() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allPatients = await _repository.getPatients();
      _applyFilters();
      AppLogger.success('Fetched ${_allPatients.length} patients');
    } catch (e) {
      _error = 'Failed to load patients';
      AppLogger.error('PatientProvider Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchPatients(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void setSortBy(PatientSortBy sortBy) {
    _sortBy = sortBy;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredPatients = _allPatients.where((patient) {
      if (_searchQuery.isEmpty) return true;

      final name = patient.name?.toLowerCase() ?? '';
      final treatments =
          patient.patientdetailsSet
              ?.map((t) => t.treatmentName?.toLowerCase() ?? '')
              .join(' ') ??
          '';

      return name.contains(_searchQuery) || treatments.contains(_searchQuery);
    }).toList();

    // Sort
    if (_sortBy == PatientSortBy.date) {
      _filteredPatients.sort(
        (a, b) => (b.dateNdTime ?? DateTime(0)).compareTo(
          a.dateNdTime ?? DateTime(0),
        ),
      );
    } else {
      _filteredPatients.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    }
  }
}
