// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Respo _$RespoFromJson(Map<String, dynamic> json) => Respo(
      success: json['success'] as bool,
      data: json['data'],
      error: json['error'] as String?,
    );

Map<String, dynamic> _$RespoToJson(Respo instance) => <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'error': instance.error,
    };
