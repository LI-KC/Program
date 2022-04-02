class Testing {
  late final int id;
  late final String name;
  late final String email;
  // if not late then have to initalize, becoz of null safety
  late final String gender;
  // can use ? to define it as 'can be null', need define before use, late also
  late final String status;

  Testing.all({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  Testing.on9({
    required this.id,
    required this.name,
  });

  factory Testing.fromJsonAll(Map<String, dynamic> json) {
    return Testing.all(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        gender: json['gender'],
        status: json['status']);
  }

  factory Testing.fromJsonOn9(Map<String, dynamic> json) {
    return Testing.on9(id: json['id'], name: json['name']);
  }

  @override
  toString() {
    return "id: " +
        id.toString() +
        ", name: " +
        name +
        ", email: " +
        email +
        ", gender: " +
        gender +
        ", status: " +
        status;
  }
}
