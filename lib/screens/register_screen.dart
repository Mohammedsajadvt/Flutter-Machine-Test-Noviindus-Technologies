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
  Future<void> _handleSave(AuthProvider authProvider, PatientProvider patientProvider) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() { _isSubmitting = true; });
      try {
        final data = {
          'name': _name ?? '',
          'whatsapp': _whatsappNumber ?? '',
          'address': _address ?? '',
          'location': _location ?? '',
          'branch': _branch ?? '',
          'treatments': jsonEncode(_selectedTreatments),
          'total_amount': _totalAmount ?? '',
          'discount_amount': _discountAmount ?? '',
          'payment_option': _paymentOption ?? '',
          'advance_amount': _advanceAmount ?? '',
          'balance_amount': _balanceAmount ?? '',
          'treatment_date': _treatmentDate ?? '',
          'treatment_time_hour': _treatmentTimeHour ?? '',
          'treatment_time_minute': _treatmentTimeMinute ?? '',
        };
        final success = await patientProvider.registerPatient(data, authProvider.token!);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration submitted!')),
          );
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20, top: 20),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              final treatmentProvider = Provider.of<TreatmentProvider>(context, listen: false);
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Choose Treatment',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF404040),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Add Treatment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF006837), width: 1.5),
                      ),
                    ),
                    value: selectedTreatmentId,
                    items: treatmentProvider.treatments.map((treatment) {
                      return DropdownMenuItem<String>(
                        value: treatment.id,
                        child: Text(treatment.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedTreatmentId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  _GenderCounterRow(
                    label: 'Male',
                    count: maleCount,
                    onAdd: () => setModalState(() => maleCount++),
                    onRemove: () { if (maleCount > 0) setModalState(() => maleCount--); },
                  ),
                  const SizedBox(height: 16),
                  _GenderCounterRow(
                    label: 'Female',
                    count: femaleCount,
                    onAdd: () => setModalState(() => femaleCount++),
                    onRemove: () { if (femaleCount > 0) setModalState(() => femaleCount--); },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5132),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
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
                      child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              );
            },
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
                  DropdownButtonFormField<String>(
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
                    items: ['Location 1', 'Location 2', 'Location 3'].map((String value) {
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
                        'Selected Treatments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF404040),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._selectedTreatments.map((t) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(t['name'], style: const TextStyle(fontSize: 15, color: Color(0xFF404040)))),
                            Row(
                              children: [
                                const Icon(Icons.male, color: Color(0xFF006837), size: 20),
                                const SizedBox(width: 2),
                                Text('${t['male']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 12),
                                const Icon(Icons.female, color: Color(0xFF006837), size: 20),
                                const SizedBox(width: 2),
                                Text('${t['female']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              SizedBox(height: 16),
              _HorizontalPad(
                child: CustomButton(
                  text: '+ Add Treatments',
                  onPressed: () => _showTreatmentModal(context),
                  color: Color(0xFF006837),
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