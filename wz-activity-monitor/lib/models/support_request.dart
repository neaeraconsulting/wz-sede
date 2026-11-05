import 'package:json_annotation/json_annotation.dart';

part 'support_request.g.dart';

@JsonSerializable()
class SupportRequest {
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'subject')
  final String subject;
  @JsonKey(name: 'message')
  final String message;

  SupportRequest({
    required this.username,
    required this.subject,
    required this.message,
  });

  factory SupportRequest.fromJson(Map<String, dynamic> json) =>
      _$SupportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SupportRequestToJson(this);
}
