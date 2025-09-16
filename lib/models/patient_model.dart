class Patient {
  final String id;
  final String name;
  final String excecutive;
  final String payment;
  final String phone;
  final String address;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final String dateNdTime;
  final List<int> male;
  final List<int> female;
  final String branch;
  final List<int> treatments;

  Patient({
    required this.id,
    required this.name,
    required this.excecutive,
    required this.payment,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateNdTime,
    required this.male,
    required this.female,
    required this.branch,
    required this.treatments,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      excecutive: json['excecutive'] ?? '',
      payment: json['payment'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      advanceAmount: (json['advance_amount'] ?? 0).toDouble(),
      balanceAmount: (json['balance_amount'] ?? 0).toDouble(),
      dateNdTime: json['date_nd_time'] ?? '',
      male: (json['male'] ?? '').toString().split(',').where((e) => e.isNotEmpty).map((e) => int.tryParse(e) ?? 0).toList(),
      female: (json['female'] ?? '').toString().split(',').where((e) => e.isNotEmpty).map((e) => int.tryParse(e) ?? 0).toList(),
      branch: json['branch'] ?? '',
      treatments: (json['treatments'] ?? '').toString().split(',').where((e) => e.isNotEmpty).map((e) => int.tryParse(e) ?? 0).toList(),
    );
  }
}
