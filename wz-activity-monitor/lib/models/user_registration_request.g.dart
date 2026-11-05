// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_registration_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistrationRequest _$UserRegistrationRequestFromJson(
        Map<String, dynamic> json) =>
    UserRegistrationRequest(
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      password: json['password'] as String,
      phoneNumber: json['phone_number'] as String,
      message: json['message'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$UserRegistrationRequestToJson(
        UserRegistrationRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number': instance.phoneNumber,
      'password': instance.password,
      'message': instance.message,
      'platform': instance.platform,
    };
