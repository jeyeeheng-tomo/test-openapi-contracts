//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'voucher.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Voucher {
  /// Returns a new [Voucher] instance.
  Voucher({
    required this.id,

    required this.name,

    required this.description,

    required this.expiresAt,
  });

  /// Opaque voucher identifier (UUID v7).
  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  /// Short label shown in the voucher list.
  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  /// Longer copy explaining what the voucher is good for.
  @JsonKey(name: r'description', required: true, includeIfNull: false)
  final String description;

  /// When the voucher stops being redeemable. Always UTC. A voucher is expired when this instant is in the past; the server does not remove expired vouchers from the list.
  @JsonKey(name: r'expires_at', required: true, includeIfNull: false)
  final DateTime expiresAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Voucher &&
          other.id == id &&
          other.name == name &&
          other.description == description &&
          other.expiresAt == expiresAt;

  @override
  int get hashCode =>
      id.hashCode + name.hashCode + description.hashCode + expiresAt.hashCode;

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
