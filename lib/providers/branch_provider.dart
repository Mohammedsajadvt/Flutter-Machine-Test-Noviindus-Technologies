import 'package:flutter/material.dart';
import 'package:novindus/services/branch_service.dart';
import 'package:novindus/models/branch_model.dart';

class BranchProvider extends ChangeNotifier {
  List<Branch> _branches = [];
  bool _isLoading = false;
  String? _error;

  List<Branch> get branches => _branches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBranches(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _branches = await BranchService().getBranches(token);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
