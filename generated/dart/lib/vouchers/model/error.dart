//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Error {
  /// Returns a new [Error] instance.
  Error({required this.code, required this.message, this.details});

  /// Stable, machine-readable error code.
  @JsonKey(name: r'code', required: true, includeIfNull: false)
  final String code;

  /// Human-readable explanation. Do not parse this.
  @JsonKey(name: r'message', required: true, includeIfNull: false)
  final String message;

  /// Optional structured context for the error.
  @JsonKey(name: r'details', required: false, includeIfNull: false)
  final Map<String, Object>? details;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error &&
          other.code == code &&
          other.message == message &&
          other.details == details;

  @override
  int get hashCode => code.hashCode + message.hashCode + details.hashCode;

  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
