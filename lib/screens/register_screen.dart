import 'package:flutter/material.dart';
import 'package:novindus/core/constants/helpers.dart';
import 'package:novindus/core/widgets/CustomButton.dart';
import 'package:novindus/core/widgets/CustomTextField.dart';
import 'package:provider/provider.dart';
import 'package:novindus/providers/branch_provider.dart';
import 'package:novindus/providers/treatment_provider.dart';
import 'package:novindus/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _whatsappNumber, _address, _location, _branch, _treatment, 
         _totalAmount, _discountAmount, _advanceAmount, _balanceAmount, 
         _treatmentDate, _treatmentTimeHour, _treatmentTimeMinute;
  int _maleCount = 0, _femaleCount = 0;
  String? _paymentOption;

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
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: double.infinity,
                  child: Divider(
                    thickness: 1,
                    color: Color(0xFF404040),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: CustomTextField(
                  label: 'Name', 
                  hint: 'Enter your full name',
                  onChanged: (value) => _name = value,
                ),
              ),
              
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: CustomTextField(
                  label: 'Whatsapp Number', 
                  hint: 'Enter your Whatsapp number',
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => _whatsappNumber = value,
                ),
              ),
              
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: CustomTextField(
                  label: 'Address', 
                  hint: 'Enter your full address',
                  maxLines: 3,
                  onChanged: (value) => _address = value,
                ),
              ),
              
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: TextStyle(
                        color: Color(0xFF404040),
                        fontWeight: FontWeight.w500,
                        fontSize: 16
                      ),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Choose your location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFF006837))
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)
                      ),
                      icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
                      items: ['Location 1', 'Location 2', 'Location 3'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value, 
                          child: Text(value, style: TextStyle(color: Color(0xFF404040)))
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _location = value;
                        });
                      },
                    ),
                  ],
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
                    Text(
                      'Branch',
                      style: TextStyle(
                        color: Color(0xFF404040),
                        fontWeight: FontWeight.w500,
                        fontSize: 16
                      ),
                    ),
                    SizedBox(height: 8),
                    Consumer<BranchProvider>(
                      builder: (context, branchProvider, _) {
                        if (branchProvider.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'Select the branch',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFF006837))
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)
                          ),
                          icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
                          items: branchProvider.branches.map((branch) {
                            return DropdownMenuItem<String>(
                              value: branch.id,
                              child: Text(branch.name, style: TextStyle(color: Color(0xFF404040)))
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
                ),
              ),
              SizedBox(height: 20),

              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: Consumer<TreatmentProvider>(
                  builder: (context, treatmentProvider, _) {
                    if (treatmentProvider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Select treatment',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFF006837))
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)
                      ),
                      icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
                      items: treatmentProvider.treatments.map((treatment) {
                        return DropdownMenuItem<String>(
                          value: treatment.id,
                          child: Text(treatment.name, style: TextStyle(color: Color(0xFF404040)))
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _treatment = value;
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: CustomButton(
                  text: '+ Add Treatments', 
                  onPressed: () {}, 
                  color: Color(0xFF006837), 
                  textColor: Colors.white
                ),
              ),
              SizedBox(height: 20),

              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: CustomTextField(
                  label: 'Total Amount', 
                  hint: '',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _totalAmount = value,
                ),
              ),
              
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: CustomTextField(
                  label: 'Discount Amount', 
                  hint: '',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _discountAmount = value,
                ),
              ),
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
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Cash', style: TextStyle(color: Color(0xFF404040))), 
                      value: 'Cash', 
                      groupValue: _paymentOption,
                      activeColor: Color(0xFF006837),
                      onChanged: (value) { 
                        setState(() { 
                          _paymentOption = value; 
                        }); 
                      }
                    )
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Card', style: TextStyle(color: Color(0xFF404040))), 
                      value: 'Card', 
                      groupValue: _paymentOption,
                      activeColor: Color(0xFF006837),
                      onChanged: (value) { 
                        setState(() { 
                          _paymentOption = value; 
                        }); 
                      }
                    )
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('UPI', style: TextStyle(color: Color(0xFF404040))), 
                      value: 'UPI', 
                      groupValue: _paymentOption,
                      activeColor: Color(0xFF006837),
                      onChanged: (value) { 
                        setState(() { 
                          _paymentOption = value; 
                        }); 
                      }
                    )
                  ),
                ],
              ),
              SizedBox(height: 16),

              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: CustomTextField(
                  label: 'Advance Amount', 
                  hint: '',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _advanceAmount = value,
                ),
              ),
              
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: CustomTextField(
                  label: 'Balance Amount', 
                  hint: '',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _balanceAmount = value,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: CustomTextField(
                  label: 'Treatment Date', 
                  hint: '',
                  readOnly: true,
                  suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF006837)),
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2025),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Color(0xFF006837),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setState(() {
                        _treatmentDate = "${date.day}/${date.month}/${date.year}";
                      });
                    }
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Treatment Time',
                            style: TextStyle(
                              color: Color(0xFF404040),
                              fontWeight: FontWeight.w500,
                              fontSize: 16
                            ),
                          ),
                          SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Hour',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Color(0xFF006837))
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)
                            ),
                            icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
                            items: List.generate(24, (index) => DropdownMenuItem<String>(
                              value: index.toString().padLeft(2, '0'), 
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: TextStyle(color: Color(0xFF404040))
                              )
                            )),
                            onChanged: (value) {
                              setState(() {
                                _treatmentTimeHour = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '',
                            style: TextStyle(
                              color: Color(0xFF404040),
                              fontWeight: FontWeight.w500,
                              fontSize: 16
                            ),
                          ),
                          SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Minutes',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Color(0xFF006837))
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)
                            ),
                            icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
                            items: List.generate(60, (index) => DropdownMenuItem<String>(
                              value: index.toString().padLeft(2, '0'), 
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: TextStyle(color: Color(0xFF404040))
                              )
                            )),
                            onChanged: (value) {
                              setState(() {
                                _treatmentTimeMinute = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: CustomButton(
                  text: 'Save', 
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('Form submitted successfully!');
                    }
                  }, 
                  color: Color(0xFF006837), 
                  textColor: Colors.white
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}