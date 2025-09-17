import 'package:flutter/material.dart';
import 'package:novindus/services/patient_service.dart';
import 'package:novindus/models/patient_model.dart';

class PatientProvider extends ChangeNotifier {
  List<Patient> _patients = [];
  bool _isLoading = false;
  String? _error;

  // Search and sort state
  String _searchQuery = '';
  String _sortBy = 'Date';

  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;

  // Filtered and sorted patients
  List<Patient> get filteredPatients {
    List<Patient> filtered = _patients.where((p) {
      final name = p.name.toLowerCase();
      final treatmentNames = p.patientDetails.map((d) => d.treatmentName).join(', ').toLowerCase();
      return name.contains(_searchQuery.toLowerCase()) || treatmentNames.contains(_searchQuery.toLowerCase());
    }).toList();
    if (_sortBy == 'Name') {
      filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else if (_sortBy == 'Date') {
      filtered.sort((a, b) => b.dateNdTime.compareTo(a.dateNdTime));
    } else if (_sortBy == 'Treatment') {
      filtered.sort((a, b) {
        final aTreat = a.patientDetails.map((d) => d.treatmentName).join(', ');
        final bTreat = b.patientDetails.map((d) => d.treatmentName).join(', ');
        return aTreat.toLowerCase().compareTo(bTreat.toLowerCase());
      });
    }
    return filtered;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  Future<void> fetchPatients(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _patients = await PatientService().getPatients(token);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> registerPatient(Map<String, dynamic> data, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await PatientService().registerPatient(data, token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
