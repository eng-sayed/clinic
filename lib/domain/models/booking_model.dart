import 'dart:convert';

class BookingModel {
  String? name;
  String? phone;
  String? age;
  String? comment;
  String? uid;
  BookingModel({
    this.name,
    this.phone,
    this.age,
    this.comment,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (age != null) {
      result.addAll({'age': age});
    }
    if (comment != null) {
      result.addAll({'comment': comment});
    }
    if (uid != null) {
      result.addAll({'uid': uid});
    }

    return result;
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      name: map['name'],
      phone: map['phone'],
      age: map['age'],
      comment: map['comment'],
      uid: map['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingModel.fromJson(String source) =>
      BookingModel.fromMap(json.decode(source));

  BookingModel copyWith({
    String? name,
    String? phone,
    String? age,
    String? comment,
    String? uid,
  }) {
    return BookingModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      comment: comment ?? this.comment,
      uid: uid ?? this.uid,
    );
  }
}
