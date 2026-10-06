// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import 'package:uuid/uuid.dart';
import '../models/create_user_request.dart';
import '../models/error.dart';
import '../models/user.dart';
import './item/with_user_item_request_builder.dart';
import './users_get_response.dart';
import './users_request_builder_get_query_parameters.dart';

/// auto generated
/// Builds and executes requests for operations under \users
class UsersRequestBuilder extends BaseRequestBuilder<UsersRequestBuilder> {
    /// Gets an item from the api_contracts.users.users.item collection
    ///  [userId] Opaque user identifier (UUID v7).
    WithUserItemRequestBuilder byUserId(UuidValue userId) {
        var urlTplParams = Map.of(pathParameters);
        urlTplParams.putIfAbsent('userId', () => userId);
        return WithUserItemRequestBuilder(urlTplParams, requestAdapter);
    }
    /// Clones the requestbuilder.
    @override
    UsersRequestBuilder clone() {
        return UsersRequestBuilder(pathParameters, requestAdapter);
    }
    /// Instantiates a new [UsersRequestBuilder] and sets the default values.
    ///  [pathParameters] Path parameters for the request
    ///  [requestAdapter] The request adapter to use to execute the requests.
    UsersRequestBuilder(Map<String, dynamic> pathParameters, RequestAdapter requestAdapter) : super(requestAdapter, "{+baseurl}/users{?email*,page_size*,page_token*}", pathParameters) ;
    /// Instantiates a new [UsersRequestBuilder] and sets the default values.
    ///  [rawUrl] The raw URL to use for the request builder.
    ///  [requestAdapter] The request adapter to use to execute the requests.
    UsersRequestBuilder.withUrl(String rawUrl, RequestAdapter requestAdapter) : super(requestAdapter, "{+baseurl}/users{?email*,page_size*,page_token*}", {RequestInformation.rawUrlKey : rawUrl}) ;
    /// List users
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    Future<UsersGetResponse?> getAsync([void Function(RequestConfiguration<UsersRequestBuilderGetQueryParameters>)? requestConfiguration]) async {
        var requestInfo = toGetRequestInformation(requestConfiguration);
        final errorMapping = <String, ParsableFactory<Parsable>>{
            '400' :  Error.createFromDiscriminatorValue,
            '401' :  Error.createFromDiscriminatorValue,
        };
        return await requestAdapter.send<UsersGetResponse>(requestInfo, UsersGetResponse.createFromDiscriminatorValue, errorMapping);
    }
    /// Create a user
    ///  [body] The request body
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    Future<User?> postAsync(CreateUserRequest body, [void Function(RequestConfiguration<DefaultQueryParameters>)? requestConfiguration]) async {
        var requestInfo = toPostRequestInformation(body, requestConfiguration);
        final errorMapping = <String, ParsableFactory<Parsable>>{
            '400' :  Error.createFromDiscriminatorValue,
            '401' :  Error.createFromDiscriminatorValue,
            '409' :  Error.createFromDiscriminatorValue,
        };
        return await requestAdapter.send<User>(requestInfo, User.createFromDiscriminatorValue, errorMapping);
    }
    /// List users
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    RequestInformation toGetRequestInformation([void Function(RequestConfiguration<UsersRequestBuilderGetQueryParameters>)? requestConfiguration]) {
        var requestInfo = RequestInformation(httpMethod : HttpMethod.get, urlTemplate : urlTemplate, pathParameters :  pathParameters);
        requestInfo.configure<UsersRequestBuilderGetQueryParameters>(requestConfiguration, () => UsersRequestBuilderGetQueryParameters());
        requestInfo.headers.put('Accept', 'application/json');
        return requestInfo;
    }
    /// Create a user
    ///  [body] The request body
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    RequestInformation toPostRequestInformation(CreateUserRequest body, [void Function(RequestConfiguration<DefaultQueryParameters>)? requestConfiguration]) {
        var requestInfo = RequestInformation(httpMethod : HttpMethod.post, urlTemplate : urlTemplate, pathParameters :  pathParameters);
        requestInfo.configure<DefaultQueryParameters>(requestConfiguration, () => DefaultQueryParameters());
        requestInfo.headers.put('Accept', 'application/json');
        requestInfo.setContentFromParsable(requestAdapter, 'application/json', body);
        return requestInfo;
    }
}
