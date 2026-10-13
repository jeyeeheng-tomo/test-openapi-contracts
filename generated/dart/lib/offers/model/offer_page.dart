//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_contracts/offers/model/offer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_page.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OfferPage {
  /// Returns a new [OfferPage] instance.
  OfferPage({required this.data, this.nextPageToken});

  @JsonKey(name: r'data', required: true, includeIfNull: false)
  final List<Offer> data;

  /// Pass as `page_token` to fetch the next page. Absent on the last page.
  @JsonKey(name: r'next_page_token', required: false, includeIfNull: false)
  final String? nextPageToken;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfferPage &&
          other.data == data &&
          other.nextPageToken == nextPageToken;

  @override
  int get hashCode => data.hashCode + nextPageToken.hashCode;

  factory OfferPage.fromJson(Map<String, dynamic> json) =>
      _$OfferPageFromJson(json);

  Map<String, dynamic> toJson() => _$OfferPageToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
