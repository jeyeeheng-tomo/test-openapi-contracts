// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import '../../../models/error.dart';
import '../../../models/order.dart';
import './cancel_post_request_body.dart';

/// auto generated
/// Builds and executes requests for operations under \orders\{orderId}\cancel
class CancelRequestBuilder extends BaseRequestBuilder<CancelRequestBuilder> {
    /// Clones the requestbuilder.
    @override
    CancelRequestBuilder clone() {
        return CancelRequestBuilder(pathParameters, requestAdapter);
    }
    /// Instantiates a new [CancelRequestBuilder] and sets the default values.
    ///  [pathParameters] Path parameters for the request
    ///  [requestAdapter] The request adapter to use to execute the requests.
    CancelRequestBuilder(Map<String, dynamic> pathParameters, RequestAdapter requestAdapter) : super(requestAdapter, "{+baseurl}/orders/{orderId}/cancel", pathParameters) ;
    /// Instantiates a new [CancelRequestBuilder] and sets the default values.
    ///  [rawUrl] The raw URL to use for the request builder.
    ///  [requestAdapter] The request adapter to use to execute the requests.
    CancelRequestBuilder.withUrl(String rawUrl, RequestAdapter requestAdapter) : super(requestAdapter, "{+baseurl}/orders/{orderId}/cancel", {RequestInformation.rawUrlKey : rawUrl}) ;
    /// Only orders in `pending` or `paid` status can be cancelled.
    ///  [body] The request body
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    Future<Order?> postAsync(CancelPostRequestBody body, [void Function(RequestConfiguration<DefaultQueryParameters>)? requestConfiguration]) async {
        var requestInfo = toPostRequestInformation(body, requestConfiguration);
        final errorMapping = <String, ParsableFactory<Parsable>>{
            '401' :  Error.createFromDiscriminatorValue,
            '404' :  Error.createFromDiscriminatorValue,
            '409' :  Error.createFromDiscriminatorValue,
        };
        return await requestAdapter.send<Order>(requestInfo, Order.createFromDiscriminatorValue, errorMapping);
    }
    /// Only orders in `pending` or `paid` status can be cancelled.
    ///  [body] The request body
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    RequestInformation toPostRequestInformation(CancelPostRequestBody body, [void Function(RequestConfiguration<DefaultQueryParameters>)? requestConfiguration]) {
        var requestInfo = RequestInformation(httpMethod : HttpMethod.post, urlTemplate : urlTemplate, pathParameters :  pathParameters);
        requestInfo.configure<DefaultQueryParameters>(requestConfiguration, () => DefaultQueryParameters());
        requestInfo.headers.put('Accept', 'application/json');
        requestInfo.setContentFromParsable(requestAdapter, 'application/json', body);
        return requestInfo;
    }
}
