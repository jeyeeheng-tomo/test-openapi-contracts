// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import 'package:microsoft_kiota_serialization_form/microsoft_kiota_serialization_form.dart';
import 'package:microsoft_kiota_serialization_json/microsoft_kiota_serialization_json.dart';
import 'package:microsoft_kiota_serialization_multipart/microsoft_kiota_serialization_multipart.dart';
import 'package:microsoft_kiota_serialization_text/microsoft_kiota_serialization_text.dart';
import './users/users_request_builder.dart';

/// auto generated
/// The main entry point of the SDK, exposes the configuration and the fluent API.
class UsersApiClient extends BaseRequestBuilder<UsersApiClient> {
    ///  The users property
    UsersRequestBuilder get users {
        return UsersRequestBuilder(pathParameters, requestAdapter);
    }
    /// Clones the requestbuilder.
    @override
    UsersApiClient clone() {
        return UsersApiClient(requestAdapter);
    }
    /// Instantiates a new [UsersApiClient] and sets the default values.
    ///  [requestAdapter] The request adapter to use to execute the requests.
    UsersApiClient(RequestAdapter requestAdapter) : super(requestAdapter, "{+baseurl}", {}) {
        ApiClientBuilder.registerDefaultSerializer(JsonSerializationWriterFactory.new);
        ApiClientBuilder.registerDefaultSerializer(TextSerializationWriterFactory.new);
        ApiClientBuilder.registerDefaultSerializer(FormSerializationWriterFactory.new);
        ApiClientBuilder.registerDefaultSerializer(MultipartSerializationWriterFactory.new);
        ApiClientBuilder.registerDefaultDeserializer(JsonParseNodeFactory.new);
        ApiClientBuilder.registerDefaultDeserializer(FormParseNodeFactory.new);
        ApiClientBuilder.registerDefaultDeserializer(TextParseNodeFactory.new);
        if (requestAdapter.baseUrl == null || requestAdapter.baseUrl!.isEmpty) {
            requestAdapter.baseUrl = 'https://api.example.com/users/v1';
        }
        pathParameters['baseurl'] = requestAdapter.baseUrl;
    }
}
