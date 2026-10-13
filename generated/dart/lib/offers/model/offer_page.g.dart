// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferPage _$OfferPageFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OfferPage', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data']);
      final val = OfferPage(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => Offer.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextPageToken: $checkedConvert('next_page_token', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'nextPageToken': 'next_page_token'});

Map<String, dynamic> _$OfferPageToJson(OfferPage instance) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'next_page_token': ?instance.nextPageToken,
};
