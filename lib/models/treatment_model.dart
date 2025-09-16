class Treatment {
  final String id;
  final String name;

  Treatment({required this.id, required this.name});

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
