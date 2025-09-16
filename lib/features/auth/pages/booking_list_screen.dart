import 'package:flutter/material.dart';
import 'package:novindus/core/constants/helpers.dart';
import 'package:novindus/core/widgets/CustomButton.dart';
import 'package:novindus/core/widgets/CustomTextField.dart';

class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  String _sortBy = 'Date';

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
          // Search and Sort Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(ResponsiveHelper.getScreenWidth(context) * 0.04),
            child: Column(
              children: [
                // Search Bar with Search Button
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
                    Container(
                      width: ResponsiveHelper.getScreenWidth(context) * 0.12,
                      height: ResponsiveHelper.getScreenHeight(context) * 0.06,
                      decoration: BoxDecoration(
                        color: Color(0xFF006837),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.getScreenWidth(context) * 0.02),
                      ),
                      child: MaterialButton(
                        onPressed: () {},
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: ResponsiveHelper.getScreenWidth(context) * 0.05,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.02),
                // Sort By Section
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
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getScreenWidth(context) * 0.03,
                        vertical: ResponsiveHelper.getScreenHeight(context) * 0.01,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.getScreenWidth(context) * 0.015),
                      ),
                      child: DropdownButton<String>(
                        value: _sortBy,
                        underline: SizedBox(),
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
                  ],
                ),
              ],
            ),
          ),
          // Booking List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(ResponsiveHelper.getScreenWidth(context) * 0.04),
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildBookingItem(
                  context,
                  index + 1,
                  'Vikram Singh',
                  'Couple Combo Package (Rejuven...',
                  index == 0 ? '31/01/2024' : '31/01/2024',
                  'Jithesh',
                );
              },
            ),
          ),
          // Register Now Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveHelper.getScreenWidth(context) * 0.04),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {},
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
            // Index Number
            Text(
              '$index.',
              style: TextStyle(
                fontSize: ResponsiveHelper.getScreenWidth(context) * 0.04,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: ResponsiveHelper.getScreenWidth(context) * 0.03),
            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getScreenWidth(context) * 0.04,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.005),
                  // Treatment
                  Text(
                    treatment,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getScreenWidth(context) * 0.035,
                      color: Color(0xFF006837),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getScreenHeight(context) * 0.01),
                  // Date and Therapist Row
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
                  // View Booking Details Button
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