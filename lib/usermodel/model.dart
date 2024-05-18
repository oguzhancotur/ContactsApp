import 'dart:convert';

class UserInfo {
  String? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? profileImageUrl;
  String? createdAt; // Değişiklik: DateTime yerine String

  UserInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (firstName != null) {
      result.addAll({'firstName': firstName});
    }
    if (lastName != null) {
      result.addAll({'lastName': lastName});
    }
    if (phoneNumber != null) {
      result.addAll({'phoneNumber': phoneNumber});
    }
    if (profileImageUrl != null) {
      result.addAll({'profileImageUrl': profileImageUrl});
    }

    return result;
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      profileImageUrl: map['profileImageUrl'],
      createdAt: map['createdAt'], // Değişiklik: String olarak al
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfo.fromJson(String source) {
    final Map<String, dynamic> map = json.decode(source);
    return UserInfo(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      profileImageUrl: map['profileImageUrl'],
      createdAt: map['createdAt'], // Değişiklik: String olarak al
    );
  }
}
