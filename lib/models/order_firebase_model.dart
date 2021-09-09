import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderFirebaseModel {
  final String? amount;
  final Timestamp? timestamp;
  final String? namebuyer;
  final String? nameproduct;
  final String? price;
  final String? status;
  final String? sum;
  final String? uidbuyer;
  OrderFirebaseModel({
    this.amount,
    this.timestamp,
    this.namebuyer,
    this.nameproduct,
    this.price,
    this.status,
    this.sum,
    this.uidbuyer,
  });

  OrderFirebaseModel copyWith({
    String? amount,
    Timestamp? timestamp,
    String? namebuyer,
    String? nameproduct,
    String? price,
    String? status,
    String? sum,
    String? uidbuyer,
  }) {
    return OrderFirebaseModel(
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      namebuyer: namebuyer ?? this.namebuyer,
      nameproduct: nameproduct ?? this.nameproduct,
      price: price ?? this.price,
      status: status ?? this.status,
      sum: sum ?? this.sum,
      uidbuyer: uidbuyer ?? this.uidbuyer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'timestamp': timestamp,
      'namebuyer': namebuyer,
      'nameproduct': nameproduct,
      'price': price,
      'status': status,
      'sum': sum,
      'uidbuyer': uidbuyer,
    };
  }

  factory OrderFirebaseModel.fromMap(Map<String, dynamic> map) {
    return OrderFirebaseModel(
      amount: map['amount'],
      timestamp: Timestamp.fromDate(map['timestamp']),
      namebuyer: map['namebuyer'],
      nameproduct: map['nameproduct'],
      price: map['price'],
      status: map['status'],
      sum: map['sum'],
      uidbuyer: map['uidbuyer'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderFirebaseModel.fromJson(String source) => OrderFirebaseModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderFirebaseModel(amount: $amount, timestamp: $timestamp, namebuyer: $namebuyer, nameproduct: $nameproduct, price: $price, status: $status, sum: $sum, uidbuyer: $uidbuyer)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OrderFirebaseModel &&
      other.amount == amount &&
      other.timestamp == timestamp &&
      other.namebuyer == namebuyer &&
      other.nameproduct == nameproduct &&
      other.price == price &&
      other.status == status &&
      other.sum == sum &&
      other.uidbuyer == uidbuyer;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
      timestamp.hashCode ^
      namebuyer.hashCode ^
      nameproduct.hashCode ^
      price.hashCode ^
      status.hashCode ^
      sum.hashCode ^
      uidbuyer.hashCode;
  }
}
