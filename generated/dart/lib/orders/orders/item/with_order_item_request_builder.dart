// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import '../../models/error.dart';
import '../../models/order.dart';
import './cancel/cancel_request_builder.dart';

/// auto generated
/// Builds and executes requests for operations under \orders\{orderId}
class WithOrderItemRequestBuilder extends BaseRequestBuilder<WithOrderItemRequestBuilder> {
    ///  The cancel property
    CancelRequestBuilder get cancel {
        return CancelRequestBuilder(pathParameters, requestAdapter);
    }
    /// Clones the requestbuilder.
    @override
    WithOrderItemRequestBuilder clone() {
        return WithOrderItemRequestBuilder(pathParameters, requestAdapter);
    }
    /// Instantiates a new [WithOrderItemRequestBuilder] and sets the default values.
    ///  [pathParameters] Path parameters for the request
    ///  [requestAdapter] The request adapter to use to execute the requests.
    WithOrderItemRequestBuilder(Map<String, dynamic> pathParameters, RequestAdapter requestAdapter) : super(requestAdapter, "{+baseurl}/orders/{orderId}", pathParameters) ;
    /// Instantiates a new [WithOrderItemRequestBuilder] and sets the default values.
    ///  [rawUrl] The raw URL to use for the request builder.
    ///  [requestAdapter] The request adapter to use to execute the requests.
    WithOrderItemRequestBuilder.withUrl(String rawUrl, RequestAdapter requestAdapter) : super(requestAdapter, "{+baseurl}/orders/{orderId}", {RequestInformation.rawUrlKey : rawUrl}) ;
    /// Get an order by id
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    Future<Order?> getAsync([void Function(RequestConfiguration<DefaultQueryParameters>)? requestConfiguration]) async {
        var requestInfo = toGetRequestInformation(requestConfiguration);
        final errorMapping = <String, ParsableFactory<Parsable>>{
            '401' :  Error.createFromDiscriminatorValue,
            '404' :  Error.createFromDiscriminatorValue,
        };
        return await requestAdapter.send<Order>(requestInfo, Order.createFromDiscriminatorValue, errorMapping);
    }
    /// Get an order by id
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    RequestInformation toGetRequestInformation([void Function(RequestConfiguration<DefaultQueryParameters>)? requestConfiguration]) {
        var requestInfo = RequestInformation(httpMethod : HttpMethod.get, urlTemplate : urlTemplate, pathParameters :  pathParameters);
        requestInfo.configure<DefaultQueryParameters>(requestConfiguration, () => DefaultQueryParameters());
        requestInfo.headers.put('Accept', 'application/json');
        return requestInfo;
    }
}
