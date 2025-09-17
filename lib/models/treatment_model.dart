class Treatment {
  final String id;
  final String name;
  final String duration;
  final String price;
  final bool isActive;
  final List<Branch> branches;
  final String createdAt;
  final String updatedAt;

  Treatment({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.branches,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price'] ?? '',
      isActive: json['is_active'] ?? true,
      branches: (json['branches'] as List<dynamic>?)
          ?.map((branch) => Branch.fromJson(branch))
          .toList() ?? [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class Branch {
  final String id;
  final String name;
  final String location;
  final String phone;
  final String mail;
  final String address;
  final String gst;
  final bool isActive;
  final int patientsCount;

  Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.mail,
    required this.address,
    required this.gst,
    required this.isActive,
    required this.patientsCount,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      mail: json['mail'] ?? '',
      address: json['address'] ?? '',
      gst: json['gst'] ?? '',
      isActive: json['is_active'] ?? true,
      patientsCount: json['patients_count'] ?? 0,
    );
  }
}
