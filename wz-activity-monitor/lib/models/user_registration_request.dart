import 'package:json_annotation/json_annotation.dart';

part 'user_registration_request.g.dart';

@JsonSerializable()
class UserRegistrationRequest {
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'platform')
  final String platform;

  UserRegistrationRequest({
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.phoneNumber,
    required this.message,
    required this.platform,
  });

  factory UserRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationRequestToJson(this);
}
