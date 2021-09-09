import 'dart:convert';

class ProfileModel {
  final String? name;
  final String? address;
  final String? phone;
  final double? lat;
  final double? lng;
  final String? token;
  ProfileModel({
    this.name,
    this.address,
    this.phone,
    this.lat,
    this.lng,
    this.token,
  });

  ProfileModel copyWith({
    String? name,
    String? address,
    String? phone,
    double? lat,
    double? lng,
    String? token,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'lat': lat,
      'lng': lng,
      'token': token,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'],
      address: map['address'],
      phone: map['phone'],
      lat: map['lat'],
      lng: map['lng'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfileModel(name: $name, address: $address, phone: $phone, lat: $lat, lng: $lng, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel &&
        other.name == name &&
        other.address == address &&
        other.phone == phone &&
        other.lat == lat &&
        other.lng == lng &&
        other.token == token;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        lat.hashCode ^
        lng.hashCode ^
        token.hashCode;
  }
}
