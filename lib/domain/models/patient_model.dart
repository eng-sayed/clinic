import 'dart:convert';

class PatientModel {
  String? name;
  String? email;
  String? id;
  String? fcmToken;
  String? image;
  String? notes;
  String? phone;
  String? treatment;
  int? age;
  int? num;
  String? role;
  PatientModel({
    this.name,
    this.email,
    this.id,
    this.fcmToken,
    this.image,
    this.notes,
    this.phone,
    this.treatment,
    this.age,
    this.num,
    this.role,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (id != null) {
      result.addAll({'id': id});
    }
    if (fcmToken != null) {
      result.addAll({'fcmToken': fcmToken});
    }
    if (image != null) {
      result.addAll({'image': image});
    }
    if (notes != null) {
      result.addAll({'notes': notes});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (treatment != null) {
      result.addAll({'treatment': treatment});
    }
    if (age != null) {
      result.addAll({'age': age});
    }
    if (num != null) {
      result.addAll({'num': num});
    }
    if (role != null) {
      result.addAll({'role': role});
    }

    return result;
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      name: map['name'],
      email: map['email'],
      id: map['id'],
      fcmToken: map['fcmToken'],
      image: map['image'],
      notes: map['notes'],
      phone: map['phone'],
      treatment: map['treatment'],
      age: map['age']?.toInt(),
      num: map['num']?.toInt(),
      role: map['role'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientModel.fromJson(String source) =>
      PatientModel.fromMap(json.decode(source));

  PatientModel copyWith({
    String? name,
    String? email,
    String? id,
    String? fcmToken,
    String? image,
    String? notes,
    String? phone,
    String? treatment,
    int? age,
    int? num,
    String? role,
  }) {
    return PatientModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      fcmToken: fcmToken ?? this.fcmToken,
      image: image ?? this.image,
      notes: notes ?? this.notes,
      phone: phone ?? this.phone,
      treatment: treatment ?? this.treatment,
      age: age ?? this.age,
      num: num ?? this.num,
      role: role ?? this.role,
    );
  }
}
