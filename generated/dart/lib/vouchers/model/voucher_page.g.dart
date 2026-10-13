// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoucherPage _$VoucherPageFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VoucherPage', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['data']);
      final val = VoucherPage(
        data: $checkedConvert(
          'data',
          (v) => (v as List<dynamic>)
              .map((e) => Voucher.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextPageToken: $checkedConvert('next_page_token', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'nextPageToken': 'next_page_token'});

Map<String, dynamic> _$VoucherPageToJson(VoucherPage instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'next_page_token': ?instance.nextPageToken,
    };
