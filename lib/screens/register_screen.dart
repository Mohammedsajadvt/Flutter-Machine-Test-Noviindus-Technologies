import 'package:flutter/material.dart';
import 'package:novindus/core/constants/helpers.dart';
import 'package:novindus/core/widgets/CustomButton.dart';
import 'package:novindus/core/widgets/CustomTextField.dart';

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
              // Header Section
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

              // Form Fields
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
              
              // Location Dropdown
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
              
              // Branch Dropdown
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
                    DropdownButtonFormField<String>(
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
                      items: ['Branch 1', 'Branch 2', 'Branch 3'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value, 
                          child: Text(value, style: TextStyle(color: Color(0xFF404040)))
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _branch = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Treatments Section
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: Text(
                  'Treatments', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF404040),
                    fontSize: 16
                  )
                ),
              ),
              SizedBox(height: 12),
              
              // Treatment Item Container
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '1. Couple Combo package i..',
                              style: TextStyle(color: Color(0xFF404040))
                            )
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Color(0xFF404040)),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red), 
                                onPressed: () {}
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Male Counter
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Color(0xFF006837),
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Male', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                SizedBox(width: 12),
                                Text(_maleCount.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          // Female Counter
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Color(0xFF006837),
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Female', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                SizedBox(width: 12),
                                Text(_femaleCount.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Counter Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle, color: Color(0xFF006837)), 
                                onPressed: () { 
                                  setState(() { 
                                    if (_maleCount > 0) _maleCount--; 
                                  }); 
                                }
                              ),
                              Text('Male', style: TextStyle(color: Color(0xFF404040))),
                              IconButton(
                                icon: Icon(Icons.add_circle, color: Color(0xFF006837)), 
                                onPressed: () { 
                                  setState(() { 
                                    _maleCount++; 
                                  }); 
                                }
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle, color: Color(0xFF006837)), 
                                onPressed: () { 
                                  setState(() { 
                                    if (_femaleCount > 0) _femaleCount--; 
                                  }); 
                                }
                              ),
                              Text('Female', style: TextStyle(color: Color(0xFF404040))),
                              IconButton(
                                icon: Icon(Icons.add_circle, color: Color(0xFF006837)), 
                                onPressed: () { 
                                  setState(() { 
                                    _femaleCount++; 
                                  }); 
                                }
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Add Treatments Button
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

              // Financial Fields
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

              // Payment Options
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

              // Amount Fields
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

              // Treatment Date
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

              // Treatment Time
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

              // Save Button
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getScreenWidth(context) * 0.050,
                  right: ResponsiveHelper.getScreenWidth(context) * 0.050 
                ),
                child: CustomButton(
                  text: 'Save', 
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
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