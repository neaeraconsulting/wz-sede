// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportRequest _$SupportRequestFromJson(Map<String, dynamic> json) =>
    SupportRequest(
      username: json['username'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$SupportRequestToJson(SupportRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'subject': instance.subject,
      'message': instance.message,
    };
