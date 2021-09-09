import 'dart:convert';

class ProductMenModel {
  final String? name;
  final String? detail;
  final String? pathImage;
  final String? uid;
  ProductMenModel({
    this.name,
    this.detail,
    this.pathImage,
    this.uid,
  });

  ProductMenModel copyWith({
    String? name,
    String? detail,
    String? pathImage,
    String? uid,
  }) {
    return ProductMenModel(
      name: name ?? this.name,
      detail: detail ?? this.detail,
      pathImage: pathImage ?? this.pathImage,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'detail': detail,
      'pathImage': pathImage,
      'uid': uid,
    };
  }

  factory ProductMenModel.fromMap(Map<String, dynamic> map) {
    return ProductMenModel(
      name: map['name'],
      detail: map['detail'],
      pathImage: map['pathImage'],
      uid: map['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductMenModel.fromJson(String source) => ProductMenModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductMenModel(name: $name, detail: $detail, pathImage: $pathImage, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductMenModel &&
      other.name == name &&
      other.detail == detail &&
      other.pathImage == pathImage &&
      other.uid == uid;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      detail.hashCode ^
      pathImage.hashCode ^
      uid.hashCode;
  }
}
