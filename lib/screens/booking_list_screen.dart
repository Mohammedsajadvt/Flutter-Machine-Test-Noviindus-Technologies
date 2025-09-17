import 'package:flutter/material.dart';
import 'package:novindus/core/constants/helpers.dart';
import 'package:novindus/core/widgets/CustomButton.dart';
import 'package:novindus/core/widgets/CustomTextField.dart';
import 'package:provider/provider.dart';
import 'package:novindus/providers/patient_provider.dart';
import 'package:novindus/providers/auth_provider.dart';

class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  String _sortBy = 'Date';
  String _searchQuery = '';
  String _searchInput = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPatients();
    });
  }

  Future<void> _fetchPatients() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    if (authProvider.token != null) {
      await patientProvider.fetchPatients(authProvider.token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(ResponsiveHelper.getScreenWidth(context) * 0.04),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: ResponsiveHelper.getScreenHeight(context) * 0.06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.getScreenWidth(context) * 0.02),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            _searchInput = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Search for treatments',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: ResponsiveHelper.getScreenWidth(context) * 0.035,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: ResponsiveHelper.getScreenWidth(context) * 0.04,
                              vertical: ResponsiveHelper.getScreenHeight(context) * 0.015,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.getScreenWidth(context) * 0.03),
                    SizedBox(width: ResponsiveHelper.getScreenWidth(context) * 0.01),
                    SizedBox(
                      width: ResponsiveHelper.getScreenWidth(context) * 0.18,
                      height: ResponsiveHelper.getScreenHeight(context) * 0.06,
                      child: CustomButton(
                        text: 'Search',
                        onPressed: () {
                          setState(() {
                            _searchQuery = _searchInput;
                          });
                        },
                        color: Color(0xFF006837),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.02),
                Row(
                  children: [
                    Text(
                      'Sort by:',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getScreenWidth(context) * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: ResponsiveHelper.getScreenHeight(context) * 0.06,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getScreenWidth(context) * 0.03,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.getScreenWidth(context) * 0.02),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _sortBy,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: ResponsiveHelper.getScreenWidth(context) * 0.045,
                          ),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: ResponsiveHelper.getScreenWidth(context) * 0.035,
                          ),
                          items: ['Date', 'Name', 'Treatment'].map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _sortBy = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<PatientProvider>(
              builder: (context, patientProvider, _) {
                if (patientProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                List filtered = patientProvider.patients.where((p) {
                  final name = p.name.toLowerCase();
                  final treatmentNames = p.patientDetails.map((d) => d.treatmentName).join(', ').toLowerCase();
                  return name.contains(_searchQuery.toLowerCase()) || treatmentNames.contains(_searchQuery.toLowerCase());
                }).toList();

                // Sort the filtered list based on dropdown
                if (_sortBy == 'Name') {
                  filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                } else if (_sortBy == 'Date') {
                  filtered.sort((a, b) => b.dateNdTime.compareTo(a.dateNdTime)); // Newest first
                } else if (_sortBy == 'Treatment') {
                  filtered.sort((a, b) {
                    final aTreat = a.patientDetails.map((d) => d.treatmentName).join(', ');
                    final bTreat = b.patientDetails.map((d) => d.treatmentName).join(', ');
                    return aTreat.toLowerCase().compareTo(bTreat.toLowerCase());
                  });
                }
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No bookings found.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _fetchPatients,
                  child: ListView.builder(
                    padding: EdgeInsets.all(ResponsiveHelper.getScreenWidth(context) * 0.04),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final patient = filtered[index];
                      final treatmentNames = patient.patientDetails.map((d) => d.treatmentName).join(', ');
                      return _buildBookingItem(
                        context,
                        index + 1,
                        patient.name,
                        treatmentNames.isNotEmpty ? treatmentNames : '-',
                        patient.dateNdTime,
                        patient.user,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveHelper.getScreenWidth(context) * 0.04),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF006837),
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.getScreenHeight(context) * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.getScreenWidth(context) * 0.02),
                ),
              ),
              child: Text(
                'Register Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.getScreenWidth(context) * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingItem(BuildContext context, int index, String name, String treatment, String date, String therapist) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.getScreenHeight(context) * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveHelper.getScreenWidth(context) * 0.02),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getScreenWidth(context) * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$index.',
              style: TextStyle(
                fontSize: ResponsiveHelper.getScreenWidth(context) * 0.04,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: ResponsiveHelper.getScreenWidth(context) * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getScreenWidth(context) * 0.04,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.005),
                  Text(
                    treatment,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getScreenWidth(context) * 0.035,
                      color: Color(0xFF006837),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.01),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: ResponsiveHelper.getScreenWidth(context) * 0.04,
                        color: Colors.red[400],
                      ),
                      SizedBox(width: ResponsiveHelper.getScreenWidth(context) * 0.01),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getScreenWidth(context) * 0.032,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.getScreenWidth(context) * 0.04),
                      Icon(
                        Icons.person_outline,
                        size: ResponsiveHelper.getScreenWidth(context) * 0.04,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: ResponsiveHelper.getScreenWidth(context) * 0.01),
                      Text(
                        therapist,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getScreenWidth(context) * 0.032,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.015),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Booking details',
                          style: TextStyle(
                            color: Color(0xFF006837),
                            fontSize: ResponsiveHelper.getScreenWidth(context) * 0.035,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.getScreenWidth(context) * 0.015),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: ResponsiveHelper.getScreenWidth(context) * 0.03,
                          color: Color(0xFF006837),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}