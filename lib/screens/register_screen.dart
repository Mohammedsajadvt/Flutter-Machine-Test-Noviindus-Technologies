import 'package:flutter/material.dart';
import 'package:novindus/core/constants/helpers.dart';
import 'package:novindus/core/widgets/CustomButton.dart';
import 'package:novindus/core/widgets/CustomTextField.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart' show Consumer2;
import 'package:novindus/providers/branch_provider.dart';
import 'package:novindus/providers/treatment_provider.dart';
import 'package:novindus/providers/auth_provider.dart';
import 'package:novindus/providers/patient_provider.dart';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CounterButton({required this.icon, required this.onTap, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF006837)),
      ),
    );
  }
}

// Helper for consistent horizontal padding
class _HorizontalPad extends StatelessWidget {
  final Widget child;
  const _HorizontalPad({required this.child, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pad = ResponsiveHelper.getScreenWidth(context) * 0.050;
    return Padding(
      padding: EdgeInsets.only(left: pad, right: pad),
      child: child,
    );
  }
}

// Gender counter row widget for reusability
class _GenderCounterRow extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  const _GenderCounterRow({required this.label, required this.count, required this.onAdd, required this.onRemove, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF404040))),
        Row(
          children: [
            _CounterButton(icon: Icons.remove, onTap: onRemove),
            Container(
              width: 44, height: 44,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text('$count', style: const TextStyle(fontSize: 18)),
            ),
            _CounterButton(icon: Icons.add, onTap: onAdd),
          ],
        ),
      ],
    );
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  Future<void> _generatePDF(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Patient Registration Details', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Name: ${data['name']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Phone: ${data['phone']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Address: ${data['address']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Location: ${data['location']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Branch: ${data['branch']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Payment: ${data['payment']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Total Amount: ${data['total_amount']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Discount Amount: ${data['discount_amount']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Advance Amount: ${data['advance_amount']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Balance Amount: ${data['balance_amount']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Date & Time: ${data['date_nd_time']}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.Text('Treatments:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ..._selectedTreatments.map((t) => pw.Text('${t['name']} - Male: ${t['male']}, Female: ${t['female']}', style: pw.TextStyle(fontSize: 14))),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _handleSave(AuthProvider authProvider, PatientProvider patientProvider) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() { _isSubmitting = true; });
      try {
        // Prepare treatment IDs and gender lists
        final treatmentIds = _selectedTreatments.map((t) => t['id']).join(',');
        final maleIds = _selectedTreatments.where((t) => t['male'] > 0).map((t) => t['id']).join(',');
        final femaleIds = _selectedTreatments.where((t) => t['female'] > 0).map((t) => t['id']).join(',');
        // Format date and time
        String dateNdTime = '';
        if (_treatmentDate != null && _treatmentTimeHour != null && _treatmentTimeMinute != null) {
          final dateParts = _treatmentDate!.split('-');
          if (dateParts.length == 3) {
            final formattedDate = '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
            final hour24 = int.parse(_treatmentTimeHour!);
            final minute = _treatmentTimeMinute!.padLeft(2, '0');
            final period = hour24 >= 12 ? 'PM' : 'AM';
            final hour12 = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
            dateNdTime = '$formattedDate-${hour12.toString().padLeft(2, '0')}:$minute $period';
          }
        }
        final data = {
          'name': _name ?? '',
          'excecutive': '', // Not present in form, left blank
          'payment': _paymentOption ?? '',
          'phone': _whatsappNumber ?? '',
          'address': _address ?? '',
          'total_amount': _totalAmount ?? '',
          'discount_amount': _discountAmount ?? '',
          'advance_amount': _advanceAmount ?? '',
          'balance_amount': _balanceAmount ?? '',
          'date_nd_time': dateNdTime,
          'id': '',
          'male': maleIds,
          'female': femaleIds,
          'branch': _branch ?? '',
          'treatments': treatmentIds,
          'location': _location ?? '',
        };
        final success = await patientProvider.registerPatient(data, authProvider.token!);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration submitted!')),
          );
          await _generatePDF(data);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      } finally {
        setState(() { _isSubmitting = false; });
      }
    }
  }
  List<Map<String, dynamic>> _selectedTreatments = [];
  void _showTreatmentModal(BuildContext context) {
    String? selectedTreatmentId;
    int maleCount = 0;
    int femaleCount = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 350),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                final treatmentProvider = Provider.of<TreatmentProvider>(context, listen: false);
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modal Header
                      const Text(
                        'Choose Treatment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Treatment Selection Section
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: SingleChildScrollView(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Add Treatment',
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            ),
                            value: selectedTreatmentId,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                            isExpanded: true,
                            menuMaxHeight: 200,
                            items: treatmentProvider.treatments.map((treatment) {
                              return DropdownMenuItem<String>(
                                value: treatment.id,
                                child: Container(
                                  constraints: const BoxConstraints(maxWidth: 280),
                                  child: Text(
                                    treatment.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedTreatmentId = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Patient Counter Section
                      const Text(
                        'Add Patients',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Male Counter Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Male',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          Row(
                            children: [
                              // Decrease Button
                              InkWell(
                                onTap: maleCount > 0
                                    ? () => setModalState(() => maleCount--)
                                    : null,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: maleCount > 0
                                        ? const Color(0xFF059669)
                                        : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Count Display
                              SizedBox(
                                width: 40,
                                child: Text(
                                  '$maleCount',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Increase Button
                              InkWell(
                                onTap: () => setModalState(() => maleCount++),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF059669),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Female Counter Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Female',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          Row(
                            children: [
                              // Decrease Button
                              InkWell(
                                onTap: femaleCount > 0
                                    ? () => setModalState(() => femaleCount--)
                                    : null,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: femaleCount > 0
                                        ? const Color(0xFF059669)
                                        : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Count Display
                              SizedBox(
                                width: 40,
                                child: Text(
                                  '$femaleCount',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Increase Button
                              InkWell(
                                onTap: () => setModalState(() => femaleCount++),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF059669),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: selectedTreatmentId != null && (maleCount > 0 || femaleCount > 0)
                              ? () {
                                  final treatment = treatmentProvider.treatments.firstWhere((t) => t.id == selectedTreatmentId);
                                  setState(() {
                                    _selectedTreatments.add({
                                      'id': selectedTreatmentId,
                                      'name': treatment.name,
                                      'male': maleCount,
                                      'female': femaleCount,
                                    });
                                  });
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedTreatmentId != null && (maleCount > 0 || femaleCount > 0)
                                ? const Color(0xFF059669)
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _editTreatment(int index, Map<String, dynamic> treatment) {
    String? selectedTreatmentId = treatment['id'];
    int maleCount = treatment['male'];
    int femaleCount = treatment['female'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 350),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                final treatmentProvider = Provider.of<TreatmentProvider>(context, listen: false);
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modal Header
                      const Text(
                        'Edit Treatment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Treatment Selection Section
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: SingleChildScrollView(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Edit Treatment',
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            ),
                            value: selectedTreatmentId,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                            isExpanded: true,
                            menuMaxHeight: 200,
                            items: treatmentProvider.treatments.map((treatment) {
                              return DropdownMenuItem<String>(
                                value: treatment.id,
                                child: Container(
                                  constraints: const BoxConstraints(maxWidth: 280),
                                  child: Text(
                                    treatment.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedTreatmentId = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Patient Counter Section
                      const Text(
                        'Add Patients',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Male Counter Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Male',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          Row(
                            children: [
                              // Decrease Button
                              InkWell(
                                onTap: maleCount > 0
                                    ? () => setModalState(() => maleCount--)
                                    : null,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: maleCount > 0
                                        ? const Color(0xFF059669)
                                        : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Count Display
                              SizedBox(
                                width: 40,
                                child: Text(
                                  '$maleCount',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Increase Button
                              InkWell(
                                onTap: () => setModalState(() => maleCount++),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF059669),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Female Counter Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Female',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          Row(
                            children: [
                              // Decrease Button
                              InkWell(
                                onTap: femaleCount > 0
                                    ? () => setModalState(() => femaleCount--)
                                    : null,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: femaleCount > 0
                                        ? const Color(0xFF059669)
                                        : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Count Display
                              SizedBox(
                                width: 40,
                                child: Text(
                                  '$femaleCount',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Increase Button
                              InkWell(
                                onTap: () => setModalState(() => femaleCount++),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF059669),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Update Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: selectedTreatmentId != null && (maleCount > 0 || femaleCount > 0)
                              ? () {
                                  final treatment = treatmentProvider.treatments.firstWhere((t) => t.id == selectedTreatmentId);
                                  setState(() {
                                    _selectedTreatments[index] = {
                                      'id': selectedTreatmentId,
                                      'name': treatment.name,
                                      'male': maleCount,
                                      'female': femaleCount,
                                    };
                                  });
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedTreatmentId != null && (maleCount > 0 || femaleCount > 0)
                                ? const Color(0xFF059669)
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
  final _formKey = GlobalKey<FormState>();
  String? _name, _whatsappNumber, _address, _location, _branch, _treatment, 
    _totalAmount, _discountAmount, _advanceAmount, _balanceAmount, 
    _treatmentDate, _treatmentTimeHour, _treatmentTimeMinute;
  int _maleCount = 0, _femaleCount = 0;
  String? _paymentOption;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    // Fetch branches and treatments on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final branchProvider = Provider.of<BranchProvider>(context, listen: false);
      final treatmentProvider = Provider.of<TreatmentProvider>(context, listen: false);
      if (authProvider.token != null) {
        if (branchProvider.branches.isEmpty) branchProvider.fetchBranches(authProvider.token!);
        if (treatmentProvider.treatments.isEmpty) treatmentProvider.fetchTreatments(authProvider.token!);
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF404040)), 
          onPressed: () => Navigator.pop(context)
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none, color: Color(0xFF404040)), 
                onPressed: () {}
              ),
              Positioned(
                right: 8, 
                top: 8,
                child: Container(
                  width: 8, 
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.getScreenWidth(context) * 0.070,
                        color: Color(0xFF404040)
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(
                  color: Color(0xFF404040).withOpacity(0.15),
                  thickness: 1.2,
                  height: 1,
                ),
              ),
              SizedBox(height: 20),

              // --- Personal Information ---
              _HorizontalPad(child: CustomTextField(
                label: 'Name',
                hint: 'Enter your full name',
                onChanged: (value) => _name = value,
              )),
              _HorizontalPad(child: CustomTextField(
                label: 'Whatsapp Number',
                hint: 'Enter your Whatsapp number',
                keyboardType: TextInputType.phone,
                onChanged: (value) => _whatsappNumber = value,
              )),
              _HorizontalPad(child: CustomTextField(
                label: 'Address',
                hint: 'Enter your full address',
                maxLines: 3,
                onChanged: (value) => _address = value,
              )),
              _HorizontalPad(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location',
                    style: TextStyle(
                      color: Color(0xFF404040),
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer<BranchProvider>(
                    builder: (context, branchProvider, _) {
                      if (branchProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final locations = branchProvider.branches.map((b) => b.location).toSet().toList();
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: 'Choose your location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF006837), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16)
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
                        items: locations.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(color: Color(0xFF404040)))
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _location = value;
                          });
                        },
                      );
                    },
                  ),
                ],
              )),
              SizedBox(height: 16),
              _HorizontalPad(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Branch',
                    style: TextStyle(
                      color: Color(0xFF404040),
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer<BranchProvider>(
                    builder: (context, branchProvider, _) {
                      if (branchProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: 'Select the branch',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF006837), width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16)
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
                        items: branchProvider.branches.map((branch) {
                          return DropdownMenuItem<String>(
                            value: branch.id,
                            child: Text(branch.name, style: const TextStyle(color: Color(0xFF404040)))
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _branch = value;
                          });
                        },
                      );
                    },
                  ),
                ],
              )),
              SizedBox(height: 20),

              // --- Treatment Details ---
              if (_selectedTreatments.isNotEmpty)
                _HorizontalPad(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Treatments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF404040),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._selectedTreatments.asMap().entries.map((entry) {
                        final i = entry.key;
                        final t = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Treatment header row
                              Row(
                                children: [
                              // Treatment name with numbering
                                  Expanded(
                                    child: Tooltip(
                                      message: '${t['name']}\nDuration: ${t['duration']}\nPrice: ₹${t['price']}',
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${i + 1}. ${t['name']}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF404040),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${t['duration']} • ₹${t['price']}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF6B7280),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Delete button
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedTreatments.removeAt(i);
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Counters and edit icon row
                              Row(
                                children: [
                                  // Male and Female counters
                                  if (t['male'] > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF22C55E),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Male',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${t['male']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (t['female'] > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF22C55E),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Female',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${t['female']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const Spacer(),
                                  // Edit icon
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color(0xFF6B7280),
                                      size: 20,
                                    ),
                                    onPressed: () => _editTreatment(i, t),
                                    tooltip: 'Edit',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              SizedBox(height: 16),
              _HorizontalPad(
                child: CustomButton(
                  text: '+ Add Treatments',
                  onPressed: () => _showTreatmentModal(context),
                  color: Color(0xFF0F5132),
                  textColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // --- Financial Information ---
              _HorizontalPad(child: CustomTextField(
                label: 'Total Amount',
                hint: '',
                keyboardType: TextInputType.number,
                onChanged: (value) => _totalAmount = value,
              )),
              _HorizontalPad(child: CustomTextField(
                label: 'Discount Amount',
                hint: '',
                keyboardType: TextInputType.number,
                onChanged: (value) => _discountAmount = value,
              )),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050
                ),
                child: Text(
                  'Payment Option',
                  style: TextStyle(
                    color: Color(0xFF404040),
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: ResponsiveHelper.getScreenWidth(context) * 0.050),
                  Expanded(
                    child: RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: Tooltip(
                        message: 'Cash',
                        child: Text('Cash',
                          style: TextStyle(color: Color(0xFF404040)),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      value: 'Cash',
                      groupValue: _paymentOption,
                      activeColor: Color(0xFF006837),
                      onChanged: (value) {
                        setState(() {
                          _paymentOption = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: Tooltip(
                        message: 'Card',
                        child: Text('Card',
                          style: TextStyle(color: Color(0xFF404040)),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      value: 'Card',
                      groupValue: _paymentOption,
                      activeColor: Color(0xFF006837),
                      onChanged: (value) {
                        setState(() {
                          _paymentOption = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: Tooltip(
                        message: 'UPI',
                        child: Text('UPI',
                          style: TextStyle(color: Color(0xFF404040)),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      value: 'UPI',
                      groupValue: _paymentOption,
                      activeColor: Color(0xFF006837),
                      onChanged: (value) {
                        setState(() {
                          _paymentOption = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _HorizontalPad(child: CustomTextField(
                label: 'Advance Amount',
                hint: '',
                keyboardType: TextInputType.number,
                onChanged: (value) => _advanceAmount = value,
              )),
              _HorizontalPad(child: CustomTextField(
                label: 'Balance Amount',
                hint: '',
                keyboardType: TextInputType.number,
                onChanged: (value) => _balanceAmount = value,
              )),
              SizedBox(height: 16),

              // --- Appointment Scheduling ---
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050
                ),
                child: CustomTextField(
                  label: 'Treatment Date',
                  hint: _treatmentDate ?? '',
                  readOnly: true,
                  suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF006837)),
                  onTap: () async {
                    final now = DateTime.now();
                    final lastDate = now.add(const Duration(days: 365));
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: now,
                      lastDate: lastDate,
                      builder: (context, child) {
                        return child!;
                      },
                    );
                    if (date != null) {
                      setState(() {
                        _treatmentDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Treatment Time',
                      style: TextStyle(
                        color: Color(0xFF404040),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Hour',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFF006837), width: 1.5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                            value: _treatmentTimeHour,
                            items: List.generate(24, (i) => i.toString().padLeft(2, '0')).map((hour) => DropdownMenuItem<String>(
                              value: hour,
                              child: Text(hour),
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                _treatmentTimeHour = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Minute',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFF006837), width: 1.5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                            value: _treatmentTimeMinute,
                            items: List.generate(60, (i) => i.toString().padLeft(2, '0')).map((min) => DropdownMenuItem<String>(
                              value: min,
                              child: Text(min),
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                _treatmentTimeMinute = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // --- Save Button ---
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getScreenWidth(context) * 0.050,
                ),
                child: Consumer2<AuthProvider, PatientProvider>(
                  builder: (context, authProvider, patientProvider, _) {
                    return CustomButton(
                      text: _isSubmitting ? 'Saving...' : 'Save',
                      onPressed: () {
                        if (!_isSubmitting) {
                          _handleSave(authProvider, patientProvider);
                        }
                      },
                      color: Color(0xFF0F5132),
                      textColor: Colors.white,
                    );
                  },
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

}
