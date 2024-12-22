// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  final int? customerId;
  final String registrationId;
  final String businessName;
  final String? regDate;
  final String? dealerCode;
  final String? parentCompany;
  final String? ownerName;
  final String? address;
  final String? contactNumber;
  final String homeDelivery;
  final double? creditLimit;
  final double depositBalance;
  final int? paymentMethodId;
  final int? customerTypeId;
  final int? priceLevelId;
  final int? routeId;
  final int? employeeId;
  final int? status;
  final String? customerVat;

  Customer({
    required this.customerId,
    required this.registrationId,
    required this.businessName,
    required this.regDate,
    this.dealerCode,
    this.parentCompany,
    required this.ownerName,
    required this.address,
    required this.contactNumber,
    required this.homeDelivery,
    this.creditLimit,
    required this.depositBalance,
    required this.paymentMethodId,
    required this.customerTypeId,
    required this.priceLevelId,
    required this.routeId,
    required this.employeeId,
    required this.status,
    this.customerVat,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
