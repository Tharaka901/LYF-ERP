// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      customerId: json['customerId'] as int?,
      registrationId: json['registrationId'] == null ? '': json['registrationId'] as String,
      businessName: json['businessName'] == null ? '' : json['businessName'] as String,
      regDate: json['regDate'] as String?,
      customerVat: json['customerVat'] as String?,
      dealerCode: json['dealerCode'] as String?,
      parentCompany: json['parentCompany'] as String?,
      ownerName: json['ownerName'] as String?,
      address: json['address'] as String?,
      contactNumber: json['contactNumber'] as String?,
      homeDelivery: json['homeDelivery'] == null ? '' : json['homeDelivery'] as String,
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
      depositBalance: (json['depositBalance'] as num).toDouble(),
      paymentMethodId: json['paymentMethodId'] as int?,
      customerTypeId: json['customerTypeId'] as int?,
      priceLevelId: json['priceLevelId'] as int?,
      routeId: json['routeId'] as int?,
      employeeId: json['employeeId'] as int?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'customerId': instance.customerId,
      'registrationId': instance.registrationId,
      'businessName': instance.businessName,
      'regDate': instance.regDate,
      'customerVat': instance.customerVat,
      'dealerCode': instance.dealerCode,
      'parentCompany': instance.parentCompany,
      'ownerName': instance.ownerName,
      'address': instance.address,
      'contactNumber': instance.contactNumber,
      'homeDelivery': instance.homeDelivery,
      'creditLimit': instance.creditLimit,
      'depositBalance': instance.depositBalance,
      'paymentMethodId': instance.paymentMethodId,
      'customerTypeId': instance.customerTypeId,
      'priceLevelId': instance.priceLevelId,
      'routeId': instance.routeId,
      'employeeId': instance.employeeId,
      'status': instance.status,
    };
