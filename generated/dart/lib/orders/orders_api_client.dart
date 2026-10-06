// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import 'package:microsoft_kiota_serialization_form/microsoft_kiota_serialization_form.dart';
import 'package:microsoft_kiota_serialization_json/microsoft_kiota_serialization_json.dart';
import 'package:microsoft_kiota_serialization_multipart/microsoft_kiota_serialization_multipart.dart';
import 'package:microsoft_kiota_serialization_text/microsoft_kiota_serialization_text.dart';
import './orders/orders_request_builder.dart';

/// auto generated
/// The main entry point of the SDK, exposes the configuration and the fluent API.
class OrdersApiClient extends BaseRequestBuilder<OrdersApiClient> {
    ///  The orders property
    OrdersRequestBuilder get orders {
        return OrdersRequestBuilder(pathParameters, requestAdapter);
    }
    /// Clones the requestbuilder.
    @override
    OrdersApiClient clone() {
        return OrdersApiClient(requestAdapter);
    }
    /// Instantiates a new [OrdersApiClient] and sets the default values.
    ///  [requestAdapter] The request adapter to use to execute the requests.
    OrdersApiClient(RequestAdapter requestAdapter) : super(requestAdapter, "{+baseurl}", {}) {
        ApiClientBuilder.registerDefaultSerializer(JsonSerializationWriterFactory.new);
        ApiClientBuilder.registerDefaultSerializer(TextSerializationWriterFactory.new);
        ApiClientBuilder.registerDefaultSerializer(FormSerializationWriterFactory.new);
        ApiClientBuilder.registerDefaultSerializer(MultipartSerializationWriterFactory.new);
        ApiClientBuilder.registerDefaultDeserializer(JsonParseNodeFactory.new);
        ApiClientBuilder.registerDefaultDeserializer(FormParseNodeFactory.new);
        ApiClientBuilder.registerDefaultDeserializer(TextParseNodeFactory.new);
        if (requestAdapter.baseUrl == null || requestAdapter.baseUrl!.isEmpty) {
            requestAdapter.baseUrl = 'https://api.example.com/orders/v1';
        }
        pathParameters['baseurl'] = requestAdapter.baseUrl;
    }
}
