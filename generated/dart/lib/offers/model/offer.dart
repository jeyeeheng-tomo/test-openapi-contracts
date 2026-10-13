//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'offer.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Offer {
  /// Returns a new [Offer] instance.
  Offer({required this.id, required this.title, required this.description});

  /// Opaque offer identifier (UUID v7).
  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  /// Short headline shown in the offer list.
  @JsonKey(name: r'title', required: true, includeIfNull: false)
  final String title;

  /// Longer copy explaining the offer.
  @JsonKey(name: r'description', required: true, includeIfNull: false)
  final String description;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Offer &&
          other.id == id &&
          other.title == title &&
          other.description == description;

  @override
  int get hashCode => id.hashCode + title.hashCode + description.hashCode;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
